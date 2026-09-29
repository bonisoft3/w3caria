---
pronto: alpha
name: w3caria
business: none — a reference implementation, published so it can be argued with
stage: polished single-feature slice
team: studio
cluster: mecha
terminal: omnishell
loop: sayt
build: bayt
---

# The Keyboard Contract — APG patterns, and the table that grades them

The ARIA Authoring Practices Guide says, for each widget pattern, exactly which
keys must do exactly what. That table is the whole specification of how a
widget behaves, and almost nobody puts it next to the widget.

This app does. Every pattern here is shown three times over: the working
widget, the published keystroke table it owes, and the published roles, states
and properties it must expose — with the app's own reading of each one beside
the text, so a place where this implementation departs from the guide is
printed rather than discovered.

It is deliberately plain. There is no visual design to admire, because the
subject is what happens when you never touch the mouse.

## Data

- `Pattern` — the patterns implemented here: what the widget is, which ARIA
  role names it, and where the guide's page for it lives.
- `Keystroke` — one row per line of a pattern's published keyboard table: the
  key, when it applies, and what it must do. Where this implementation does
  something else, the row says so in its own words.
- `Attribute` — one row per line of a pattern's published roles, states and
  properties table: the attribute, the element that carries it, and what its
  value means.
- `Option` — the members of the patterns that have members: the tabs, the
  radio buttons, the options, the sections.
- `Choice` — which member of a pattern is current. One row per pattern that
  has a current member.
- `Flag` — whether a pattern's one boolean is on: the disclosure open, the
  switch on, a section expanded.

## Screens

Two: the gallery, and one pattern's contract in full.

### 1. The gallery

Every pattern in order, and for each: a heading, a sentence, the live widget,
and the keystroke table underneath it. Beside the widget, the ARIA state it is
currently exposing — the actual attributes, read off the actual elements, so
what the table promises and what the page does are on screen together.

The whole page is operable from the keyboard alone, which is the only claim it
really makes.

### 2. The contract

One pattern, in full: every keystroke, and every role, state and property, each
with the guide's own wording and this implementation's reading of it. A row
where the two differ is marked, and says which way.

## Behavior

- **A widget has one tab stop.** Tab moves to the widget, not through it. Once
  inside, the arrow keys move between members and Tab leaves. The member that
  holds the tab stop is the current one, so returning to a widget returns to
  where you were.
- **Moving is selecting, where the pattern says it is.** In a tab list, in a
  radio group and in a single-select listbox, an arrow key moves and chooses in
  one gesture. In an accordion, it only moves; opening a section is a separate
  key.
- **The ends do not wrap, and where the guide asks for wrapping the row says
  so.** The tab list and the radio group are specified to wrap from the last
  member back to the first. This implementation stops at the ends instead, and
  every affected row is marked as a departure rather than quietly reworded.
- **Every state is a row.** Which tab is current, whether a section is open,
  whether the switch is on: all of it is stored, so a widget can be driven from
  the keyboard, from a click, or by a test, and all three go the same way.
- **Nothing here is announced twice.** The state a screen reader is told is the
  state the attribute carries; there is no second copy in a live region saying
  the same thing in prose.

![[acceptance.md]]

## Out of scope

- Patterns that open a surface over the page and move focus into it — menu
  button, dialog, combobox, tooltip. They are the next thing to try, and they
  are left out here rather than half-done.
- Multi-select listboxes, tree views, grids, and anything with a second axis.
- Drag and drop, and every pattern whose guide table is mouse-first.
- Screen-reader announcement testing. This app checks what the page exposes,
  not what any particular reader says about it.
- Visual design. It is a specimen sheet, not a product.
