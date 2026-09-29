// The gallery's markup, CUE-composed: three of the six patterns are instances
// of w3caria--rover, and every section is one shape — heading, sentence, the
// live widget in its well, then the two published tables the widget owes.
// Emitted to shell/screens/gallery.html by write.ts.
package w3caria

import (
	"strings"

	own "bonisoft.org/apps/w3caria/components:components"
)

// One pattern's section. `widget` is the live thing; the two tables under it
// are the guide's own, read out of the rows seeded from it.
#Section: S={
	id:      string
	heading: string
	blurb:   string
	widget:  string
	out: """
		  <section class="pattern" id="section-\(S.id)">
		    <header class="head">
		      <h2 data-text="\(S.heading)">\(S.heading)</h2>
		      <p class="blurb">\(S.blurb)</p>
		      <p class="more"><a data-route="contract" data-param-id="\(S.id)">The whole contract for this pattern</a></p>
		    </header>

		\(S.widget)

		    <table class="keys">
		      <caption>Keyboard interaction</caption>
		      <thead><tr><th scope="col">Key</th><th scope="col">When</th><th scope="col">The guide says</th><th scope="col">Here</th></tr></thead>
		      <tbody data-live="keystroke" data-filter="pattern_id=eq.\(S.id)" data-order="pos.asc"
		             data-empty="No keystrokes recorded for this pattern.">
		        <template data-item>
		          <tr data-departs="{departs}">
		            <th scope="row"><kbd data-text="{key}"></kbd></th>
		            <td data-text="{when}"></td>
		            <td data-text="{does}"></td>
		            <td class="reading" data-text="{reading}"></td>
		          </tr>
		        </template>
		      </tbody>
		    </table>

		    <table class="attrs">
		      <caption>Roles, states and properties</caption>
		      <thead><tr><th scope="col">Role or attribute</th><th scope="col">On</th><th scope="col">The guide says</th></tr></thead>
		      <tbody data-live="attribute" data-filter="pattern_id=eq.\(S.id)" data-order="pos.asc"
		             data-empty="No attributes recorded for this pattern.">
		        <template data-item>
		          <tr>
		            <th scope="row"><code data-text="{name}"></code></th>
		            <td><code data-text="{on}"></code></td>
		            <td data-text="{does}"></td>
		          </tr>
		        </template>
		      </tbody>
		    </table>
		  </section>
		"""
}

// A boolean the reader flips: the machine writes the state name into the
// column the ARIA attribute reads, so the semantics and the styling hook are
// one value. Enter and Space reach it as the button's own click — the platform
// activating a button is the whole of what the guide asks for here.
#Toggle: T={
	row:   string
	field: *"on" | string
	out: """
		    <div class="well" data-live="flag" data-filter="id=eq.\(T.row)"
		         data-machine='{"field":"\(T.field)","initial":"false","states":{"false":{"on":{"click":"true"}},"true":{"on":{"click":"false"}}}}'>
		\(T.inner)
		    </div>
		"""
	inner: string
}

_disclosure: #Toggle & {
	row: "disc"
	inner: """
		      <button type="button" class="disclosure" id="disc-btn" aria-expanded="{on}" aria-controls="disc-body">
		        What a roving tabstop is
		      </button>
		      <div class="disc-body" id="disc-body" data-shown="{on}">
		        <p>One member of a group is in the page's tab sequence and the rest are not, so
		        Tab reaches the group and the arrow keys move inside it. The member holding the
		        tab stop is the current one, which is why leaving and coming back returns you to
		        where you were.</p>
		      </div>
		"""
}

_switch: #Toggle & {
	row: "sw"
	inner: """
		      <span class="switch-row">
		        <span id="sw-label">Announce moves</span>
		        <button type="button" role="switch" id="sw-btn" aria-checked="{on}" aria-labelledby="sw-label">
		          <span class="track" aria-hidden="true"><span class="knob"></span></span>
		        </button>
		      </span>
		"""
}

_tabs: own.#Rover & {
	widget:   "tabs"
	role:     "tablist"
	itemRole: "tab"
	label:    "Focus models"
	state:    "aria-selected"
	panels:   true
	keys: {
		ArrowRight: "next"
		ArrowLeft:  "prev"
		Home:       "first"
		End:        "last"
	}
	options: [
		{id: "roving", label: "Roving"},
		{id: "virtual", label: "Virtual"},
		{id: "none", label: "Neither"},
	]
}

_radio: own.#Rover & {
	widget:   "radio"
	role:     "radiogroup"
	itemRole: "radio"
	label:    "Announce level"
	state:    "aria-checked"
	keys: {
		ArrowDown:  "next"
		ArrowRight: "next"
		ArrowUp:    "prev"
		ArrowLeft:  "prev"
	}
	options: [
		{id: "off", label: "Off"},
		{id: "brief", label: "Brief"},
		{id: "verbose", label: "Verbose"},
	]
}

_listbox: own.#Rover & {
	widget:   "list"
	role:     "listbox"
	itemRole: "option"
	label:    "Reading order"
	state:    "aria-selected"
	keys: {
		ArrowDown: "next"
		ArrowUp:   "prev"
		Home:      "first"
		End:       "last"
	}
	options: [
		{id: "dom", label: "Document order"},
		{id: "visual", label: "Visual order"},
		{id: "flow", label: "Reading flow"},
	]
}

// Each section is its own region and its own machine, filtered to the row its
// header is about. That nesting is what lets three sections hold three
// independent booleans without three copies of this markup: a machine belongs
// to a region, and one region per section is what "one machine per section"
// means here.
_accordion: """
	    <div class="well acc">
	      <div class="acc-list" data-live="option" data-filter="widget=eq.acc" data-order="pos.asc">
	        <template data-item>
	          <div class="section">
	            <!-- The machine's region is INSIDE the item rather than being
	                 it: a region that is another region's item root resolves
	                 its own filter against no row, and {id} would stay
	                 literal. -->
	            <div class="sec" data-live="option" data-filter="id=eq.{id}"
	                 data-machine='{"field":"open","initial":"false","states":{"false":{"on":{"click":"true"}},"true":{"on":{"click":"false"}}}}'>
	            <h3 class="acc-head">
	              <button type="button" id="acc-item-{id}" aria-expanded="{open}" aria-controls="acc-panel-{id}" data-text="{label}"></button>
	            </h3>
	            <div role="region" class="acc-panel" id="acc-panel-{id}" aria-labelledby="acc-item-{id}"
	                 data-shown="{open}" data-text="{body}"></div>
	            </div>
	          </div>
	        </template>
	      </div>
	    </div>
	"""

_sections: [
	(#Section & {
		id: "disclosure", heading: "Disclosure", widget: _disclosure.out
		blurb: "A button that shows and hides one region. The smallest pattern in the guide, and the one every other expandable thing is built out of."
	}).out,
	(#Section & {
		id: "switch", heading: "Switch", widget: _switch.out
		blurb: "A control with two states that takes effect immediately. Not a checkbox: there is no third state and no form to submit."
	}).out,
	(#Section & {
		id: "tabs", heading: "Tabs", widget: _tabs.markup
		blurb: "One panel of several on screen at a time, chosen from a strip. Automatic activation: moving to a tab shows its panel in the same gesture."
	}).out,
	(#Section & {
		id: "radio", heading: "Radio group", widget: _radio.markup
		blurb: "One choice out of a small fixed set. The arrows move and choose together, which is what makes it a radio group rather than a list."
	}).out,
	(#Section & {
		id: "listbox", heading: "Listbox", widget: _listbox.markup
		blurb: "One choice out of a list, with the same focus model as a radio group and a different role for it."
	}).out,
	(#Section & {
		id: "accordion", heading: "Accordion", widget: _accordion
		blurb: "Several disclosures stacked, any number of them open. The guide makes the arrow keys optional here, and this implementation declines them."
	}).out,
]

_galleryMarkup: """
	<section class="screen" data-screen="gallery">

	  <header class="masthead">
	    <h1 class="title">The Keyboard Contract</h1>
	    <p class="sub">Six patterns from the ARIA Authoring Practices Guide, each beside the
	    table it owes. Everything here works from the keyboard alone.</p>
	  </header>

	  <nav class="toc" aria-label="Patterns">
	    <ul data-live="pattern" data-order="pos.asc" data-empty="No patterns.">
	      <template data-item>
	        <li><a href="#section-{id}" data-text="{name}"></a></li>
	      </template>
	    </ul>
	  </nav>

	\(strings.Join(_sections, "\n"))

	</section>
	"""
