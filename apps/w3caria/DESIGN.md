---
preset: "press"
colors:
  neutral: "#FFFFFF"
  surface: "#FFFFFF"
  surface-muted: "#F4F4F2"
  border: "#D6D6D1"
  primary: "#101010"
  secondary: "#5C5C57"
  accent: "#0B4FA2"
  danger: "#A4232B"
  attention: "#8A5A00"
dark:
  neutral: "#0E0E0E"
  surface: "#0E0E0E"
  surface-muted: "#1A1A19"
  border: "#3A3A36"
  primary: "#F0F0EE"
  secondary: "#A6A69F"
  accent: "#7FB2F0"
  danger: "#F08379"
  attention: "#E0AE55"
type:
  title: "1.5rem"
  subtitle: "1.25rem"
  heading: "1rem"
  body: "0.9375rem"
  body-small: "0.875rem"
  caption: "0.8125rem"
  code: "var(--type-caption)"
  leading-code: "1.4"
---

# The Keyboard Contract — Specimen Sheet

The identity is **Specimen Sheet**: a technical document, set once, that
gets out of the way of the thing it documents.

## Why there is almost no design here

Every other app in this tree is designed to be looked at. This one is
designed to be *operated with the eyes closed*, and then read by someone
checking whether it did the right thing. Those are two audiences and
neither of them wants a mood.

So the sheet does one thing well: it makes the boundary between "the
widget" and "the text about the widget" unmistakable, and it makes the
focus ring the loudest thing on the page. Everything else recedes.

## Direction

- **White, not paper.** Unlike the chess column, this really is a
  specimen sheet: an unwarmed white ground, so nothing about the page
  suggests a texture the widgets are sitting on. The one tinted surface
  is the widget well.
- **The widget sits in a well.** Each pattern's live widget is inset on
  the one muted surface with a hairline around it. That inset is the
  whole visual system: inside it you are operating something, outside it
  you are reading about it.
- **The focus ring is the design.** It is the accent, two pixels, with a
  two-pixel offset so it never touches the thing it rings, and it is
  never removed — not on click, not on mouse-down, not anywhere. On a
  page about keyboard operation, a suppressed focus ring is not a style
  choice, it is a defect.
- **The tables are tables.** Real `<table>` markup with a header row,
  hairline rules, and the guide's wording set at reading size. The
  implementation's own reading sits in the last column, in the secondary
  colour, so the guide's text is what the eye lands on first.
- **A departure is marked once, in one colour.** Where this app does
  something other than what the guide says, the row wears the attention
  colour and a word. Not red: a departure is a stated choice, not an
  error, and colouring it as an error would be lying about it.
- **Monospace for anything that is code.** Key names, role names,
  attribute names, and attribute values. Prose is prose; `aria-expanded`
  is not prose. Code is set at the caption size rather than at a size of
  its own — one glyph run should not be a second reading size.
- **The sheet reads at 15px, and the table head is a tracked caption at
  13px.** Six purposes carry the whole document: a title, a pattern
  heading and its accordion heading, the reading size the tables and
  links share, a small link, and the caption. Nothing on the page is set
  to a number a stylesheet chose.

## Colour

An unwarmed white ground, one tinted well per widget, and a focus ring loud
enough to be the design. The accent is the ring's colour before it is
anything else, which is why it is a blue that holds contrast on both grounds
rather than the preset's green.

## Type

Six purposes cover all nine of the sheet's font-size sites at the sizes they
already wear; 1.5rem, .9375rem and .8125rem are the three no admitted ladder
names, which is what a role is for. `code` is the alias idiom: a purpose
whose whole content is "the same value as caption", which two roles at one
norm could not otherwise spell. It aliases caption rather than body-small
because every kbd and code in the sheet sits in a .9375rem context, where
an em rule would render 13.125px — .8125rem is 13px and .875rem
would be a 6.7% move that widens the 400px document by 10px.

## Motion

Effectively none, and deliberately: a page about keyboard operation must
not animate under the caret. A disclosure or accordion panel appears
without a transition — a height animation is the one thing that makes an
arrow key feel unresponsive, and it moves the target while a reader is
travelling to it. The focus ring never animates. Under
`prefers-reduced-motion` nothing changes, because there is nothing to
collapse.

## The dark twin

The same sheet on a dark ground. The accent moves to a lighter blue that
still holds contrast against the dark surface, because it is doing the
focus ring's job and the focus ring is the one thing that must never be
subtle. The attention colour that marks a departure moves the same way.
