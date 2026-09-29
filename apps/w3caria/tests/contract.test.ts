// The grader: every row of every published keyboard table, driven.
//
// The rows in `Keystroke` are the guide's own, seeded from it. This file drives
// each one against the mounted gallery and records the id it drove; the last
// case asserts the driven set is the whole seeded set, so a line of the
// specification nobody exercised fails the run and says which one.
//
// Three kinds of row need three kinds of driving, and the difference is the
// honest part. An arrow key is a binding, so it is fired as a key. Enter and
// Space on a button are the PLATFORM activating a control — nothing in this app
// listens for them — so what is checked is that the control really is a button
// and that activating it does what the row says; linkedom does not synthesise
// the click a browser would, and pretending otherwise would be testing the
// harness. A Tab row is about the tab order, so it is read off the tab order.
import { appSeed, assert, mountApp, type Mounted, only } from "../../../plugins/omnishell/test/screen-harness.ts";

const APP = new URL("../", import.meta.url);
const driven = new Set<string>();

/** Name the published row this case answers. */
const drives = (...ids: string[]) => ids.forEach((id) => driven.add(id));

const gallery = () => mountApp({ appDir: APP, screen: "gallery", seed: 1, tables: {} });

const choice = (m: Mounted, id: string) => only(m.rows("choice").filter((r) => r.id === id), `choice ${id}`).value;
const flag = (m: Mounted, id: string) => only(m.rows("flag").filter((r) => r.id === id), `flag ${id}`).on;
const section = (m: Mounted, id: string) => only(m.rows("option").filter((r) => r.id === id), `section ${id}`).open;
const members = (m: Mounted, role: string) => m.all(`[role="${role}"]`);
/** The members of a widget that are in the page's tab sequence. */
const tabbable = (m: Mounted, role: string) =>
  members(m, role).filter((el) => (el.getAttribute("tabindex") ?? "0") !== "-1");
const key = async (m: Mounted, sel: string, k: string) => {
  m.fire(sel, "keydown", { key: k, bubbles: true, cancelable: true });
  await m.settle();
};

Deno.test({
  name: "disclosure — Enter and Space activate the control, because it is a button",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    drives("disclosure-enter", "disclosure-space");
    const m = await gallery();
    await m.settle();
    const btn = m.one("#disc-btn");
    // The row is satisfied by the control's own nature: a button is activated
    // by both keys without a line of script, which is why neither key is bound.
    assert(btn.localName === "button", `the disclosure control is a <${btn.localName}>`);
    assert(btn.getAttribute("aria-expanded") === "false", "it starts expanded");
    m.fire(btn);
    await m.settle();
    assert(flag(m, "disc") === "true", `after activating it is ${flag(m, "disc")}`);
    assert(m.one("#disc-btn").getAttribute("aria-expanded") === "true", "aria-expanded did not follow the column");
    m.fire(m.one("#disc-btn"));
    await m.settle();
    assert(flag(m, "disc") === "false", "activating it again did not close it");
    await m.stop();
  },
});

Deno.test({
  name: "switch — Space toggles it, and the attribute is the column",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    drives("switch-space", "switch-enter");
    const m = await gallery();
    await m.settle();
    const btn = m.one("#sw-btn");
    assert(btn.localName === "button", `the switch is a <${btn.localName}>`);
    assert(btn.getAttribute("role") === "switch", "it does not carry role switch");
    assert(btn.getAttribute("aria-checked") === "false", "it starts on");
    m.fire(btn);
    await m.settle();
    assert(flag(m, "sw") === "true", `after activating it is ${flag(m, "sw")}`);
    assert(m.one("#sw-btn").getAttribute("aria-checked") === "true", "aria-checked did not follow the column");
    await m.stop();
  },
});

Deno.test({
  name: "tabs — Tab reaches one stop, and it is the selected tab",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    drives("tabs-tab");
    const m = await gallery();
    await m.settle();
    const stops = tabbable(m, "tab");
    assert(stops.length === 1, `${stops.length} tabs are in the page's tab sequence`);
    assert(stops[0].getAttribute("aria-selected") === "true", "the stop is not on the selected tab");
    await m.stop();
  },
});

Deno.test({
  name: "tabs — the arrows move and activate, and Home and End reach the ends",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    drives("tabs-right", "tabs-left", "tabs-home", "tabs-end");
    const m = await gallery();
    await m.settle();
    const list = "#section-tabs [role=tablist]";
    assert(choice(m, "tabs") === "roving", `the strip opens on ${choice(m, "tabs")}`);
    await key(m, list, "ArrowRight");
    assert(choice(m, "tabs") === "virtual", `Right went to ${choice(m, "tabs")}`);
    // Activation is the same gesture: the panel on screen is the one the strip
    // just moved to.
    const shown = m.all("#section-tabs [role=tabpanel]").filter((el) => el.getAttribute("data-cur") === "true");
    assert(shown.length === 1 && shown[0].id === "tabs-panel-virtual", `${shown.length} panels shown`);
    await key(m, list, "ArrowLeft");
    assert(choice(m, "tabs") === "roving", `Left went to ${choice(m, "tabs")}`);
    await key(m, list, "End");
    assert(choice(m, "tabs") === "none", `End went to ${choice(m, "tabs")}`);
    await key(m, list, "Home");
    assert(choice(m, "tabs") === "roving", `Home went to ${choice(m, "tabs")}`);
    // Exactly one tab is selected at every point, which is what the second
    // half of the published table is about.
    const sel = members(m, "tab").filter((el) => el.getAttribute("aria-selected") === "true");
    assert(sel.length === 1, `${sel.length} tabs are selected`);
    await m.stop();
  },
});

Deno.test({
  name: "radio — Tab reaches the checked button, Space checks, the arrows move and check",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    drives("radio-tab", "radio-space", "radio-next", "radio-prev");
    const m = await gallery();
    await m.settle();
    const group = "#section-radio [role=radiogroup]";
    const stops = tabbable(m, "radio");
    assert(stops.length === 1, `${stops.length} radio buttons are in the tab sequence`);
    assert(stops[0].getAttribute("aria-checked") === "true", "the stop is not on the checked button");
    await key(m, group, "ArrowDown");
    assert(choice(m, "radio") === "verbose", `Down went to ${choice(m, "radio")}`);
    await key(m, group, "ArrowUp");
    assert(choice(m, "radio") === "brief", `Up went to ${choice(m, "radio")}`);
    await key(m, group, "ArrowRight");
    assert(choice(m, "radio") === "verbose", `Right went to ${choice(m, "radio")}`);
    await key(m, group, "ArrowLeft");
    assert(choice(m, "radio") === "brief", `Left went to ${choice(m, "radio")}`);
    // Space on a button that is not checked checks it: the member is a submit
    // button of its own form, so the platform's activation is the write.
    const off = m.one("#radio-item-off");
    assert(off.getAttribute("type") === "submit", `the member is type=${off.getAttribute("type")}`);
    // A submit button IS the write: the platform turns Space into a click and
    // a click on a submit button into the form's submission. linkedom does the
    // first half and not the second, so the gesture is driven at the form.
    m.fire("#radio-pick-off", "submit");
    await m.settle();
    assert(choice(m, "radio") === "off", `activating it checked ${choice(m, "radio")}`);
    const checked = members(m, "radio").filter((el) => el.getAttribute("aria-checked") === "true");
    assert(checked.length === 1, `${checked.length} radio buttons are checked`);
    await m.stop();
  },
});

Deno.test({
  name: "listbox — the arrows move and select, and the ends are reachable",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    drives("listbox-down", "listbox-up", "listbox-home", "listbox-end");
    const m = await gallery();
    await m.settle();
    const list = "#section-listbox [role=listbox]";
    await key(m, list, "ArrowDown");
    assert(choice(m, "list") === "visual", `Down went to ${choice(m, "list")}`);
    await key(m, list, "ArrowUp");
    assert(choice(m, "list") === "dom", `Up went to ${choice(m, "list")}`);
    await key(m, list, "End");
    assert(choice(m, "list") === "flow", `End went to ${choice(m, "list")}`);
    await key(m, list, "Home");
    assert(choice(m, "list") === "dom", `Home went to ${choice(m, "list")}`);
    const sel = members(m, "option").filter((el) => el.getAttribute("aria-selected") === "true");
    assert(sel.length === 1, `${sel.length} options are selected`);
    await m.stop();
  },
});

Deno.test({
  name: "the ends stop where the guide would wrap, and the rows say so",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    const m = await gallery();
    await m.settle();
    const list = "#section-tabs [role=tablist]";
    await key(m, list, "End");
    await key(m, list, "ArrowRight");
    assert(choice(m, "tabs") === "none", `Right at the last tab went to ${choice(m, "tabs")}`);
    await key(m, list, "Home");
    await key(m, list, "ArrowLeft");
    assert(choice(m, "tabs") === "roving", `Left at the first tab went to ${choice(m, "tabs")}`);
    // The behaviour is a stated departure, so the count of rows wearing that
    // mark is part of the assertion: quietly fixing one without unmarking it,
    // or unmarking one without fixing it, fails here.
    const marked = m.rows("keystroke").filter((r) => r.departs === "stops");
    assert(marked.length === 4, `${marked.length} rows are marked as stopping`);
    for (const row of marked) {
      assert(String(row.does).includes("wrap") || String(row.does).includes("first") || String(row.does).includes("last"),
        `${row.id} is marked as stopping but the guide's text does not ask it to wrap`);
    }
    await m.stop();
  },
});

Deno.test({
  name: "accordion — Enter and Space open a section, Tab reaches every header, the arrows are declined",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    drives("accordion-enter", "accordion-space", "accordion-tab", "accordion-down", "accordion-up");
    const m = await gallery();
    await m.settle();
    const heads = m.all("#section-accordion .acc-head button");
    assert(heads.length === 3, `${heads.length} accordion headers`);
    // Every header is its own stop: the arrow keys are declined, so nothing
    // takes them out of the tab sequence.
    assert(heads.every((el) => (el.getAttribute("tabindex") ?? "0") !== "-1"),
      "a header was taken out of the tab sequence");
    assert(heads.every((el) => el.localName === "button"), "a header is not a button");
    m.fire(heads[0]);
    await m.settle();
    assert(section(m, "why") === "true", "the first section did not open");
    m.fire(m.all("#section-accordion .acc-head button")[1]);
    await m.settle();
    // More than one may stand open, and each says which it is.
    assert(section(m, "why") === "true" && section(m, "what") === "true", "opening the second closed the first");
    const expanded = m.all("#section-accordion .acc-head button")
      .filter((el) => el.getAttribute("aria-expanded") === "true");
    assert(expanded.length === 2, `${expanded.length} headers say they are expanded`);
    // The declined rows: the arrows do nothing here, which is the behaviour
    // the row states.
    const before = m.rows("option").filter((r) => r.widget === "acc").map((r) => r.open).join();
    await key(m, "#section-accordion .acc-list", "ArrowDown");
    await key(m, "#section-accordion .acc-list", "ArrowUp");
    const after = m.rows("option").filter((r) => r.widget === "acc").map((r) => r.open).join();
    assert(before === after, "an arrow key moved something in the accordion");
    await m.stop();
  },
});

Deno.test({
  name: "every keystroke the guide publishes for these patterns was driven",
  sanitizeOps: false,
  sanitizeResources: false,
  async fn() {
    const seeded = (await appSeed(APP)).keystroke.map((r) => String(r.id));
    const missing = seeded.filter((id) => !driven.has(id));
    const stray = [...driven].filter((id) => !seeded.includes(id));
    assert(stray.length === 0, `driven rows that are not in the table: ${stray.join(", ")}`);
    assert(missing.length === 0, `published rows nothing drove: ${missing.join(", ")}`);
    assert(seeded.length === 22, `the table has ${seeded.length} rows, not the 22 the ir states`);
  },
});
