// The second published table, graded the same way as the first.
//
// Every row of `Attribute` is a claim about an element: a role the element must
// carry, or an `aria-` property it must have. Each row names that element with
// a selector, so the claim has a subject a check can go and look at — which is
// the difference between a table of promises and a table of assertions.
//
// The run fails on a row whose element is missing, on a row whose element does
// not carry what the row says, and on a row nothing looked at.
import { appSeed, assert, mountApp, type Mounted } from "../../../plugins/omnishell/test/screen-harness.ts";

const APP = new URL("../", import.meta.url);
type Row = Record<string, unknown>;

const gallery = () => mountApp({ appDir: APP, screen: "gallery", seed: 1, tables: {} });

/** What the row claims, checked against what the page has. */
const check = (m: Mounted, row: Row): string | null => {
  const name = String(row.name);
  const probe = String(row.probe);
  const found = m.all(probe);
  if (found.length === 0) return `${row.id}: nothing matches ${probe}`;
  if (!name.startsWith("aria-")) {
    // A role row. `button` is the element itself, not an attribute — the
    // guide names native semantics the same way it names an explicit role,
    // and so does this.
    const wrong = found.filter((el) =>
      name === "button" ? el.localName !== "button" : el.getAttribute("role") !== name
    );
    if (wrong.length > 0) return `${row.id}: ${wrong.length} of ${found.length} elements at ${probe} are not ${name}`;
    return null;
  }
  const bare = found.filter((el) => !el.hasAttribute(name));
  if (bare.length > 0) return `${row.id}: ${bare.length} of ${found.length} elements at ${probe} lack ${name}`;
  return null;
};

Deno.test({
  name: "every published role, state and property is on the page, on the element its row names",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    const m = await gallery();
    await m.settle();
    const rows = m.rows("attribute");
    const seeded = (await appSeed(APP)).attribute;
    assert(rows.length === seeded.length, `${rows.length} attribute rows rendered, ${seeded.length} seeded`);
    assert(rows.length === 24, `the table has ${rows.length} rows, not the 24 the ir states`);
    const problems = rows.map((r) => check(m, r)).filter((p): p is string => p !== null);
    assert(problems.length === 0, `\n  ${problems.join("\n  ")}`);
    await m.stop();
  },
});

Deno.test({
  name: "the states the tables name are the columns the widgets hold, and exactly one member wears each",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    const m = await gallery();
    await m.settle();
    // aria-selected and aria-checked are claims about a SET, and the row can
    // only say each member carries the attribute. That exactly one carries it
    // true is the invariant behind the row, so it is asserted here.
    for (const [role, attr] of [["tab", "aria-selected"], ["radio", "aria-checked"], ["option", "aria-selected"]]) {
      const on = m.all(`[role="${role}"]`).filter((el) => el.getAttribute(attr) === "true");
      assert(on.length === 1, `${on.length} ${role}s carry ${attr}="true"`);
    }
    // aria-controls and aria-labelledby have to point at something that is
    // there: a reference to a missing id is worse than no reference.
    for (const el of m.all("[aria-controls], [aria-labelledby]")) {
      for (const attr of ["aria-controls", "aria-labelledby"]) {
        const target = el.getAttribute(attr);
        if (target === null) continue;
        assert(m.all(`#${target}`).length === 1, `${attr} on ${el.id || el.localName} names ${target}, which is not on the page`);
      }
    }
    await m.stop();
  },
});

Deno.test({
  name: "every widget with members is one stop in the page's tab sequence",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    const m = await gallery();
    await m.settle();
    for (const role of ["tab", "radio", "option"]) {
      const stops = m.all(`[role="${role}"]`).filter((el) => (el.getAttribute("tabindex") ?? "0") !== "-1");
      assert(stops.length === 1, `${stops.length} of the ${role}s are in the tab sequence`);
    }
    await m.stop();
  },
});

Deno.test({
  name: "the gallery carries every pattern with both of its tables",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    const m = await gallery();
    await m.settle();
    const patterns = m.rows("pattern");
    assert(patterns.length === 6, `${patterns.length} patterns`);
    for (const p of patterns) {
      assert(m.all(`#section-${p.id}`).length === 1, `no section for ${p.id}`);
      assert(m.all(`#section-${p.id} table.keys`).length === 1, `no keystroke table for ${p.id}`);
      assert(m.all(`#section-${p.id} table.attrs`).length === 1, `no attribute table for ${p.id}`);
      // The rows in each table are that pattern's, and all of them.
      const keys = m.rows("keystroke").filter((r) => r.pattern_id === p.id);
      const shown = m.all(`#section-${p.id} table.keys tbody tr`);
      assert(shown.length === keys.length, `${p.id} shows ${shown.length} of its ${keys.length} keystrokes`);
    }
    await m.stop();
  },
});
