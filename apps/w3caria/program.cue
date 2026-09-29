// The machine rung of apps/w3caria: a pronto.#App compiled from ir.html
// (pinned below). Nobody reviews this; it must merely be checkable.
//
// Every entity takes the `tab` path (ir decision-01), so this program emits no
// migration, no policy, no publication and no pipeline. The six seeded tables
// ARE the app: the guide's two published tables per pattern, the members of
// the patterns that have members, and the two columns a reader writes.
@extern(embed)

package w3caria

import (
	pronto "bonisoft.org/plugins/pronto"
)

_designMd: _ @embed(file="DESIGN.md", type=text)

code: pronto.#App & {
	state: {
		entities: {
			Pattern: {
				id: "0x8d2dff6be1a41645"
				table: "pattern"
				durability: "tab"
				fields: [
					{ordinal: 1, name: "id", type: "string", pk: true, cel: "this.size() <= 24"},
					{ordinal: 2, name: "name", type: "string", cel: "this.size() > 0"},
					{ordinal: 3, name: "role", type: "string", cel: "this.size() <= 24"},
					{ordinal: 4, name: "apg", type: "string", cel: "this.startsWith('https://')"},
					{ordinal: 5, name: "pos", type: "int32", cel: "this >= 1"},
				]
				seed: [
					{id: "disclosure", name: "Disclosure", role: "button", apg: "https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/", pos: 1},
					{id: "switch", name: "Switch", role: "switch", apg: "https://www.w3.org/WAI/ARIA/apg/patterns/switch/", pos: 2},
					{id: "tabs", name: "Tabs", role: "tablist", apg: "https://www.w3.org/WAI/ARIA/apg/patterns/tabs/", pos: 3},
					{id: "radio", name: "Radio group", role: "radiogroup", apg: "https://www.w3.org/WAI/ARIA/apg/patterns/radio/", pos: 4},
					{id: "listbox", name: "Listbox", role: "listbox", apg: "https://www.w3.org/WAI/ARIA/apg/patterns/listbox/", pos: 5},
					{id: "accordion", name: "Accordion", role: "button", apg: "https://www.w3.org/WAI/ARIA/apg/patterns/accordion/", pos: 6},
				]
			}
			Keystroke: {
				id: "0xd74394fca38707f5"
				table: "keystroke"
				durability: "tab"
				fields: [
					{ordinal: 1, name: "id", type: "string", pk: true, cel: "this.size() <= 40"},
					{ordinal: 2, name: "pattern_id", type: "string", cel: "this.size() <= 24"},
					{ordinal: 3, name: "key", type: "string", cel: "this.size() > 0"},
					{ordinal: 4, name: "when", type: "string", cel: "this.size() > 0"},
					{ordinal: 5, name: "does", type: "string", cel: "this.size() > 0"},
					{ordinal: 6, name: "reading", type: "string", cel: "this.size() > 0"},
					// How this implementation stands to the published text:
					// as written, stopping where the guide wraps, or declining
					// an optional behaviour outright.
					{ordinal: 7, name: "departs", type: "string", cel: "this in ['no', 'stops', 'declined']"},
					{ordinal: 8, name: "pos", type: "int32", cel: "this >= 1"},
				]
				seed: [
					{id: "disclosure-enter", pattern_id: "disclosure", key: "Enter", when: "Focus is on the disclosure button", does: "Activates the disclosure control and toggles the visibility of the disclosure content.", reading: "As written. The control is a button, so the platform activates it and nothing here listens for the key.", departs: "no", pos: 1},
					{id: "disclosure-space", pattern_id: "disclosure", key: "Space", when: "Focus is on the disclosure button", does: "Activates the disclosure control and toggles the visibility of the disclosure content.", reading: "As written, and for the same reason.", departs: "no", pos: 2},

					{id: "switch-space", pattern_id: "switch", key: "Space", when: "Focus is on the switch", does: "Toggles the switch between on and off.", reading: "As written.", departs: "no", pos: 1},
					{id: "switch-enter", pattern_id: "switch", key: "Enter", when: "Focus is on the switch", does: "Optional: toggles the switch between on and off.", reading: "Implemented. The switch is a button, so declining Enter would have taken work.", departs: "no", pos: 2},

					{id: "tabs-tab", pattern_id: "tabs", key: "Tab", when: "Focus moves into or out of the tab list", does: "When focus moves into the tab list, places focus on the active tab element. When the tab list contains focus, moves focus to the next element in the page tab sequence outside the tab list.", reading: "As written. The tab list is one stop, and the stop sits on the selected tab.", departs: "no", pos: 1},
					{id: "tabs-right", pattern_id: "tabs", key: "Right Arrow", when: "Focus is on a tab", does: "Moves focus to the next tab. If focus is on the last tab, moves focus to the first tab. Activates the newly focused tab.", reading: "Moves and activates, but stops on the last tab rather than wrapping to the first.", departs: "stops", pos: 2},
					{id: "tabs-left", pattern_id: "tabs", key: "Left Arrow", when: "Focus is on a tab", does: "Moves focus to the previous tab. If focus is on the first tab, moves focus to the last tab. Activates the newly focused tab.", reading: "Moves and activates, but stops on the first tab rather than wrapping to the last.", departs: "stops", pos: 3},
					{id: "tabs-home", pattern_id: "tabs", key: "Home", when: "Focus is on a tab", does: "Moves focus to the first tab and activates it.", reading: "As written.", departs: "no", pos: 4},
					{id: "tabs-end", pattern_id: "tabs", key: "End", when: "Focus is on a tab", does: "Moves focus to the last tab and activates it.", reading: "As written.", departs: "no", pos: 5},

					{id: "radio-tab", pattern_id: "radio", key: "Tab", when: "Focus moves into or out of the group", does: "Moves focus into and out of the radio group. When focus moves into the group, focus is set on the checked button.", reading: "As written. The tab stop sits on the checked button.", departs: "no", pos: 1},
					{id: "radio-space", pattern_id: "radio", key: "Space", when: "Focus is on a radio button that is not checked", does: "Checks the focused radio button.", reading: "As written. The button submits its own choice.", departs: "no", pos: 2},
					{id: "radio-next", pattern_id: "radio", key: "Right Arrow, Down Arrow", when: "Focus is on a radio button", does: "Moves focus to and checks the next radio button. If focus is on the last button, moves focus to and checks the first button.", reading: "Moves and checks, but stops on the last button rather than wrapping to the first.", departs: "stops", pos: 3},
					{id: "radio-prev", pattern_id: "radio", key: "Left Arrow, Up Arrow", when: "Focus is on a radio button", does: "Moves focus to and checks the previous radio button. If focus is on the first button, moves focus to and checks the last button.", reading: "Moves and checks, but stops on the first button rather than wrapping to the last.", departs: "stops", pos: 4},

					{id: "listbox-down", pattern_id: "listbox", key: "Down Arrow", when: "Focus is on an option", does: "Moves focus to and selects the next option.", reading: "As written. The guide does not ask a single-select listbox to wrap, so stopping at the end is the specified behaviour here.", departs: "no", pos: 1},
					{id: "listbox-up", pattern_id: "listbox", key: "Up Arrow", when: "Focus is on an option", does: "Moves focus to and selects the previous option.", reading: "As written.", departs: "no", pos: 2},
					{id: "listbox-home", pattern_id: "listbox", key: "Home", when: "Focus is on an option", does: "Optional: moves focus to and selects the first option.", reading: "Implemented.", departs: "no", pos: 3},
					{id: "listbox-end", pattern_id: "listbox", key: "End", when: "Focus is on an option", does: "Optional: moves focus to and selects the last option.", reading: "Implemented.", departs: "no", pos: 4},

					{id: "accordion-enter", pattern_id: "accordion", key: "Enter", when: "Focus is on an accordion header", does: "Activates the header, expanding or collapsing the panel it controls.", reading: "As written.", departs: "no", pos: 1},
					{id: "accordion-space", pattern_id: "accordion", key: "Space", when: "Focus is on an accordion header", does: "Activates the header, expanding or collapsing the panel it controls.", reading: "As written.", departs: "no", pos: 2},
					{id: "accordion-tab", pattern_id: "accordion", key: "Tab", when: "Focus is on an accordion header", does: "Moves focus to the next focusable element.", reading: "As written. Every header is its own stop in the page's tab sequence.", departs: "no", pos: 3},
					{id: "accordion-down", pattern_id: "accordion", key: "Down Arrow", when: "Focus is on an accordion header", does: "Optional: moves focus to the next accordion header.", reading: "Taking it means a roving tab stop, and a roving tab stop takes the headers out of the tab sequence the row above puts them in.", departs: "declined", pos: 4},
					{id: "accordion-up", pattern_id: "accordion", key: "Up Arrow", when: "Focus is on an accordion header", does: "Optional: moves focus to the previous accordion header.", reading: "With the row above.", departs: "declined", pos: 5},
				]
			}
			Attribute: {
				id: "0x85bafc442228e975"
				table: "attribute"
				durability: "tab"
				fields: [
					{ordinal: 1, name: "id", type: "string", pk: true, cel: "this.size() <= 40"},
					{ordinal: 2, name: "pattern_id", type: "string", cel: "this.size() <= 24"},
					{ordinal: 3, name: "name", type: "string", cel: "this.size() > 0"},
					{ordinal: 4, name: "on", type: "string", cel: "this.size() > 0"},
					{ordinal: 5, name: "does", type: "string", cel: "this.size() > 0"},
					// The element the claim is about, as a selector. Not shown
					// to a reader — it is how the check finds what the row
					// names, and having it is the difference between a table
					// that is read and a table that is enforced.
					{ordinal: 6, name: "probe", type: "string", cel: "this.size() > 0"},
					{ordinal: 7, name: "pos", type: "int32", cel: "this >= 1"},
				]
				seed: [
					{id: "disclosure-button", pattern_id: "disclosure", name: "button", on: "the disclosure control", does: "The control is a button, so Enter and Space activate it with no script.", probe: "#disc-btn", pos: 1},
					{id: "disclosure-expanded", pattern_id: "disclosure", name: "aria-expanded", on: "the disclosure button", does: "Says whether the content the button controls is visible.", probe: "#disc-btn", pos: 2},
					{id: "disclosure-controls", pattern_id: "disclosure", name: "aria-controls", on: "the disclosure button", does: "References the element the button shows and hides.", probe: "#disc-btn", pos: 3},

					{id: "switch-role", pattern_id: "switch", name: "switch", on: "the control", does: "The role that says this is a two-state control taking effect at once.", probe: "#sw-btn", pos: 1},
					{id: "switch-checked", pattern_id: "switch", name: "aria-checked", on: "the switch", does: "true when the switch is on, false when it is off.", probe: "#sw-btn", pos: 2},
					{id: "switch-labelledby", pattern_id: "switch", name: "aria-labelledby", on: "the switch", does: "Names the switch from the text beside it.", probe: "#sw-btn", pos: 3},

					{id: "tabs-tablist", pattern_id: "tabs", name: "tablist", on: "the strip", does: "Contains the set of tabs.", probe: "#section-tabs [role=tablist]", pos: 1},
					{id: "tabs-tab-role", pattern_id: "tabs", name: "tab", on: "each tab", does: "One selectable tab of the strip.", probe: "#section-tabs [role=tab]", pos: 2},
					{id: "tabs-tabpanel", pattern_id: "tabs", name: "tabpanel", on: "each panel", does: "The content one tab reveals.", probe: "#section-tabs [role=tabpanel]", pos: 3},
					{id: "tabs-selected", pattern_id: "tabs", name: "aria-selected", on: "each tab", does: "true on the one selected tab, false on the rest.", probe: "#section-tabs [role=tab]", pos: 4},
					{id: "tabs-controls", pattern_id: "tabs", name: "aria-controls", on: "each tab", does: "References the panel that tab reveals.", probe: "#section-tabs [role=tab]", pos: 5},
					{id: "tabs-labelledby", pattern_id: "tabs", name: "aria-labelledby", on: "each panel", does: "References the tab that labels the panel.", probe: "#section-tabs [role=tabpanel]", pos: 6},

					{id: "radio-group-role", pattern_id: "radio", name: "radiogroup", on: "the group", does: "Contains the set of radio buttons.", probe: "#section-radio [role=radiogroup]", pos: 1},
					{id: "radio-role", pattern_id: "radio", name: "radio", on: "each button", does: "One button of the group.", probe: "#section-radio [role=radio]", pos: 2},
					{id: "radio-checked", pattern_id: "radio", name: "aria-checked", on: "each radio button", does: "true on the one checked button, false on the rest.", probe: "#section-radio [role=radio]", pos: 3},
					{id: "radio-label", pattern_id: "radio", name: "aria-label", on: "the group", does: "Names the group.", probe: "#section-radio [role=radiogroup]", pos: 4},

					{id: "listbox-role", pattern_id: "listbox", name: "listbox", on: "the list", does: "Contains the set of options.", probe: "#section-listbox [role=listbox]", pos: 1},
					{id: "listbox-option", pattern_id: "listbox", name: "option", on: "each option", does: "One option of the list.", probe: "#section-listbox [role=option]", pos: 2},
					{id: "listbox-selected", pattern_id: "listbox", name: "aria-selected", on: "each option", does: "true on the one selected option, false on the rest.", probe: "#section-listbox [role=option]", pos: 3},
					{id: "listbox-label", pattern_id: "listbox", name: "aria-label", on: "the list", does: "Names the list.", probe: "#section-listbox [role=listbox]", pos: 4},

					{id: "accordion-expanded", pattern_id: "accordion", name: "aria-expanded", on: "each header button", does: "Says whether that section's panel is visible.", probe: "#section-accordion .acc-head button", pos: 1},
					{id: "accordion-controls", pattern_id: "accordion", name: "aria-controls", on: "each header button", does: "References the panel the header shows and hides.", probe: "#section-accordion .acc-head button", pos: 2},
					{id: "accordion-region", pattern_id: "accordion", name: "region", on: "each panel", does: "Makes the panel a landmark a reader can move to directly.", probe: "#section-accordion [role=region]", pos: 3},
					{id: "accordion-labelledby", pattern_id: "accordion", name: "aria-labelledby", on: "each panel", does: "References the header button that labels the panel.", probe: "#section-accordion [role=region]", pos: 4},
				]
			}
			Option: {
				id: "0xdf5e45e2e4a68817"
				table: "option"
				durability: "tab"
				fields: [
					{ordinal: 1, name: "id", type: "string", pk: true, cel: "this.size() <= 24"},
					{ordinal: 2, name: "widget", type: "string", cel: "this.size() <= 24"},
					{ordinal: 3, name: "label", type: "string", cel: "this.size() > 0"},
					{ordinal: 4, name: "body", type: "string", required: false, cel: "this.size() <= 400"},
					// The accordion's own boolean. Every other widget's members
					// carry it as false and no markup reads it there.
					{ordinal: 5, name: "open", type: "string", cel: "this in ['true', 'false']"},
					{ordinal: 6, name: "pos", type: "int32", cel: "this >= 1"},
				]
				seed: [
					{id: "roving", widget: "tabs", label: "Roving", open: "false", pos: 1, body: "One member of the group is in the page's tab sequence; the rest carry tabindex -1. Moving the tab stop moves DOM focus with it."},
					{id: "virtual", widget: "tabs", label: "Virtual", open: "false", pos: 2, body: "Focus never leaves the container. aria-activedescendant names the active row, and no element is ever focused but the container itself."},
					{id: "none", widget: "tabs", label: "Neither", open: "false", pos: 3, body: "Every member is in the tab sequence. Right for a small set of unrelated controls, wrong for a list, and the reason a list needs one of the two above."},

					{id: "off", widget: "radio", label: "Off", open: "false", pos: 1},
					{id: "brief", widget: "radio", label: "Brief", open: "false", pos: 2},
					{id: "verbose", widget: "radio", label: "Verbose", open: "false", pos: 3},

					{id: "dom", widget: "list", label: "Document order", open: "false", pos: 1},
					{id: "visual", widget: "list", label: "Visual order", open: "false", pos: 2},
					{id: "flow", widget: "list", label: "Reading flow", open: "false", pos: 3},

					{id: "why", widget: "acc", label: "Why the tables are on the page", open: "false", pos: 1, body: "A widget's behaviour is a specification, and a specification nobody can see beside the thing is one nobody checks. Putting the table here makes a departure something you read rather than something you find."},
					{id: "what", widget: "acc", label: "What is checked, and how", open: "false", pos: 2, body: "Every row of every keystroke table is driven by a test that names it, and the run fails if a row is never driven. Every row of every attribute table names an element, and a second check asserts that element carries what the row says."},
					{id: "wont", widget: "acc", label: "What is not here", open: "false", pos: 3, body: "Every pattern that opens a surface over the page and moves focus into it: menu button, dialog, combobox, tooltip. They are the next thing to try, and half of one would say less than none."},
				]
			}
			Choice: {
				id: "0xab920ec0f2a12cce"
				table: "choice"
				durability: "tab"
				fields: [
					{ordinal: 1, name: "id", type: "string", pk: true, cel: "this.size() <= 24"},
					{ordinal: 2, name: "value", type: "string", cel: "this.size() <= 24"},
				]
				seed: [
					{id: "tabs", value: "roving"},
					{id: "radio", value: "brief"},
					{id: "list", value: "dom"},
				]
			}
			Flag: {
				id: "0x943e3eb3016a38e6"
				table: "flag"
				durability: "tab"
				fields: [
					{ordinal: 1, name: "id", type: "string", pk: true, cel: "this.size() <= 24"},
					{ordinal: 2, name: "on", type: "string", cel: "this in ['true', 'false']"},
				]
				seed: [
					{id: "disc", on: "false"},
					{id: "sw", on: "false"},
				]
			}
		}
		pipelines: {}
	}

	capabilities: {
		blobs: false
		hatches: {}
		vendored: {}
	}

	surface: {
		screens: {
			gallery: {
				title:  "Patterns"
				route:  "/"
				markup: _galleryMarkup
				forms: []
				states: ["loading", "empty", "populated", "expanded", "populated-dark", "network-error"]
				files: {
					shared: ["shell/shared/sheet.css"]
				}
			}
			contract: {
				title: "Contract"
				route: "/contract/:id"
				strip: false
				keep:  0
				forms: []
				states: ["empty", "populated", "populated-dark"]
				files: {
					shared: ["shell/shared/sheet.css"]
				}
			}
		}

		handlers: {}

		design: (pronto.#DesignMd & {text: _designMd}).design

		flows: {
			"toggle-flag": {of: "gallery", entity: "Flag", action: "update"}
			"toggle-section": {of: "gallery", entity: "Option", action: "update"}
			"pick-member": {of: "gallery", entity: "Choice", action: "upsert"}
			"move-tabstop": {of: "gallery", entity: "Choice", action: "upsert"}
			"open-contract": {of: "gallery", entity: "Pattern", action: "navigate"}
		}
	}

	meta: {
		name:        "w3caria"
		description: "Six ARIA Authoring Practices patterns, each beside the published table that grades it."
		ir: {sha256: "4d80a16e2bd1bea92ac5a78db7b23515bc882d332a44b6b53adf7503f801149f"}
		targets: ["pages"]
		decisions: {
			"decision-01": {}
			"decision-02": {}
			"decision-03": {}
			"decision-04": {}
			"decision-05": {}
			"decision-06": {}
			"decision-07": {}
			"decision-08": {}
			"decision-09": {}
			"decision-10": {}
			"decision-11": {}
			"decision-12": {}
		}
		tests: {
			"test-every-keystroke": {
				of: "Keystroke"
				says:  "every row of every published keystroke table is driven by a check that names it, and the run fails if one is never driven"
				given: {rows: 22, patterns: 6}
				when:  "the contract suite runs"
				then:  "output.driven == input.rows && output.undriven == []"
			}
			"test-every-attribute": {
				of: "Attribute"
				says:  "every element a published attribute row names is on the page carrying what the row says it carries"
				given: {rows: 24}
				when:  "the aria suite runs"
				then:  "output.missing == [] && output.checked == input.rows"
			}
			"test-one-tab-stop": {
				of: "Choice"
				says:  "a tab list, a radio group and a listbox are each one stop in the page's tab sequence, and the stop is on the current member"
				given: {widgets: ["tabs", "radio", "list"]}
				when:  "render"
				then:  "output.tabbable.all(n, n == 1) && output.stopIsCurrent"
			}
			"test-tabs-arrows": {
				of: "Choice"
				says:  "the arrows move the tab and activate it in one gesture, Home and End reach the ends, and exactly one tab is selected throughout"
				given: {start: "roving"}
				when:  "ArrowRight, ArrowRight, ArrowLeft, Home, End"
				then:  "output.value == \"none\" && output.selectedCount == 1 && output.panelShown == output.value"
			}
			"test-radio-arrows": {
				of: "Choice"
				says:  "the arrows move and check together, Space checks the button with focus, and exactly one button is checked"
				given: {start: "brief"}
				when:  "ArrowDown, ArrowUp, Space"
				then:  "output.checkedCount == 1 && output.value == \"brief\""
			}
			"test-listbox-arrows": {
				of: "Choice"
				says:  "the arrows move and select, the ends are reachable, and exactly one option is selected"
				given: {start: "dom"}
				when:  "ArrowDown, End, Home"
				then:  "output.value == \"dom\" && output.selectedCount == 1"
			}
			"test-ends-stop": {
				of: "Choice"
				says:  "an arrow at the end of a set names the member it is already on, so the tab list and the radio group stop where the guide would have them wrap — and every affected row says so"
				given: {at: "last"}
				when:  "ArrowRight"
				then:  "output.value == input.at && output.rowsMarkedStops == 4"
			}
			"test-disclosure": {
				of: "Flag"
				says:  "the disclosure button toggles its content and says which state it is in"
				given: {on: "false"}
				when:  "Enter, then Space"
				then:  "output.afterEnter == \"true\" && output.afterSpace == \"false\" && output.expandedMatches"
			}
			"test-switch": {
				of: "Flag"
				says:  "the switch toggles with Space and carries role switch with aria-checked"
				given: {on: "false"}
				when:  "Space"
				then:  "output.on == \"true\" && output.role == \"switch\" && output.checked == output.on"
			}
			"test-accordion": {
				of: "Option"
				says:  "the accordion headers open and close independently and more than one section may stand open"
				given: {sections: 3}
				when:  "open the first, then the second"
				then:  "output.open == 2 && output.expanded == output.open"
			}
			"test-gallery": {
				of: "gallery"
				says:  "every pattern is on the gallery with its live widget and both of its tables"
				given: {patterns: 6}
				when:  "render"
				then:  "output.sections == input.patterns && output.keyTables == input.patterns && output.attrTables == input.patterns"
			}
			"test-contract": {
				of: "contract"
				says:  "a pattern's contract page shows that pattern's keystrokes and attributes and no other pattern's"
				given: {pattern: "tabs"}
				when:  "open /contract/tabs"
				then:  "output.keystrokes == 5 && output.attributes == 6 && output.otherPatterns == 0"
			}
			"test-appearance": {
				of: "gallery"
				says:  "both appearances render, every target is a thumb wide, and nothing animates"
				given: {minSize: 24}
				when:  "render"
				then:  "output.smallestTarget >= input.minSize && output.animations == 0"
			}
		}
	}
}

cluster: (pronto.#DefaultCluster & {"code": code, statics: terminal.surface.statics}).out
terminal: (pronto.#DefaultTerminal & {"code": code}).out
loop: (pronto.#DefaultLoop & {"code": code, "cluster": cluster, "terminal": terminal}).out

// The grader. It drives every row of the published keystroke tables against
// the mounted gallery and fails if a row was never driven — the table is the
// checklist, and coverage of it is the check.
loop: surface: checks: "contract": {
	verb: "test"
	cmds: [
		"deno test --config tests/deno.json --no-lock --no-check --allow-env --allow-read tests/contract.test.ts",
	]
	note: "every keystroke the guide publishes for these six patterns, driven against the emitted markup, with coverage of the table asserted at the end"
}

// The second table, graded the same way: every role, state and property row
// names an element, and the element has to be there carrying it.
loop: surface: checks: "aria": {
	verb: "test"
	cmds: [
		"deno test --config tests/deno.json --no-lock --no-check --allow-env --allow-read tests/aria.test.ts",
	]
	note: "every published role, state and property present on the element its row names, on the rendered gallery"
}

build: (pronto.#DefaultBuild & {"code": code, "loop": loop, "cluster": cluster}).out

out: pronto.#emit & {"code": code, "cluster": cluster, "terminal": terminal, "loop": loop, "build": build}
