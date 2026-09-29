// w3caria--rover: the shape three APG patterns share — a set of members, one
// of them current, a roving tabstop on the current one, and arrow keys that
// move it. Tabs, radio groups and single-select listboxes differ in the role
// names, the state attribute and whether they carry panels; they do not differ
// in any of the mechanics, which is why they are one definition.
//
// Every gesture is a form. The arrows submit the per-member forms the hidden
// region renders from the `next`/`prev` projection; Home and End submit a pair
// the component writes with the first and last member's key in them, because
// the projection names a row's neighbours and no row can name the set's ends.
// A pointer submits the member's own form. All three write the same column, so
// the widget goes the same way however it was driven.
package components

import "strings"

#Rover: R={
	// The `choice` row this widget's current member is stored in, and the
	// prefix every id here is built from.
	widget: string
	// The container's role, and its members'.
	role:     string
	itemRole: string
	label:    string
	// The state attribute the current member carries — APG spells it
	// aria-selected for a tab and an option, aria-checked for a radio.
	state: "aria-selected" | "aria-checked"
	// Whether each member has a panel the container labels. Tabs do; a radio
	// group and a listbox do not.
	panels: *false | bool
	options: [...{id: string, label: string, body: *"" | string}] & [_, _, ...]
	// Which key moves where. Written per instance rather than defaulted,
	// because which arrows a pattern answers to IS the pattern's contract and
	// a default would hide it.
	keys: [string]: "next" | "prev" | "first" | "last"

	_first: R.options[0].id
	_last:  R.options[len(R.options) - 1].id
	_form: {
		next:  "\(R.widget)-nx-{value}"
		prev:  "\(R.widget)-pv-{value}"
		first: "\(R.widget)-home"
		last:  "\(R.widget)-end"
	}
	_keymap: strings.Join([for k, dir in R.keys {"\"\(k)\":\"\(_form[dir])\""}], ",")

	_panelAttrs: [
		if R.panels {" aria-controls=\"\(R.widget)-panel-{id}\""},
		"",
	][0]

	_members: strings.Join([for _ in ["one"] {
		"""
			      <template data-item>
			        <form role="none" class="pick" id="\(R.widget)-pick-{id}" data-form="\(R.widget)-pick" data-entity="choice" data-action="upsert">
			          <input type="hidden" name="id" data-value="\(R.widget)">
			          <input type="hidden" name="value" data-value="{id}">
			          <button type="submit" role="\(R.itemRole)" id="\(R.widget)-item-{id}"
			                  data-rove="{cur}" \(R.state)="{cur}"\(_panelAttrs) data-text="{label}"></button>
			        </form>
			      </template>
			"""
	}], "")

	_panelBlock: [
		if R.panels {
			"""

			    <div class="panels" data-live="option" data-filter="widget=eq.\(R.widget)" data-order="pos.asc"
			         data-project='{"cur":{"eq":["id","{value}"]}}'>
			      <template data-item>
			        <div role="tabpanel" id="\(R.widget)-panel-{id}" aria-labelledby="\(R.widget)-item-{id}"
			             data-cur="{cur}" tabindex="0" data-text="{body}"></div>
			      </template>
			    </div>
			"""
		},
		"",
	][0]

	markup: """
		<w3caria--rover>
		  <div class="rover" data-live="choice" data-filter="id=eq.\(R.widget)">
		    <template data-item>
		      <div class="well">
		        <div class="members" role="\(R.role)" aria-label="\(R.label)"
		             data-key='{\(_keymap)}'
		             data-live="option" data-filter="widget=eq.\(R.widget)" data-order="pos.asc"
		             data-project='{"cur":{"eq":["id","{value}"]}}'>
		\(_members)
		        </div>\(_panelBlock)

		        <!-- The gestures. A key names a form; the form states the row the
		             key would write. The arrows read the neighbour off the
		             projection, so an end names itself and stopping there is what
		             the read tier does rather than a rule this widget keeps. -->
		        <div hidden class="gestures" data-live="option" data-filter="widget=eq.\(R.widget)" data-order="pos.asc"
		             data-project='{"nxt":"next","prv":"prev"}'>
		          <template data-item>
		            <div class="pair">
		              <form role="none" id="\(R.widget)-nx-{id}" data-form="\(R.widget)-nx" data-entity="choice" data-action="upsert">
		                <input type="hidden" name="id" data-value="\(R.widget)">
		                <input type="hidden" name="value" data-value="{nxt}">
		              </form>
		              <form role="none" id="\(R.widget)-pv-{id}" data-form="\(R.widget)-pv" data-entity="choice" data-action="upsert">
		                <input type="hidden" name="id" data-value="\(R.widget)">
		                <input type="hidden" name="value" data-value="{prv}">
		              </form>
		            </div>
		          </template>
		        </div>
		        <!-- The set's two ends, which no row can name: the projection
		             answers about a row's neighbours, never about the set. The
		             member list is compile-time data, so the component writes
		             them in. -->
		        <div hidden class="gestures">
		          <form role="none" id="\(R.widget)-home" data-form="\(R.widget)-home" data-entity="choice" data-action="upsert">
		            <input type="hidden" name="id" data-value="\(R.widget)">
		            <input type="hidden" name="value" data-value="\(_first)">
		          </form>
		          <form role="none" id="\(R.widget)-end" data-form="\(R.widget)-end" data-entity="choice" data-action="upsert">
		            <input type="hidden" name="id" data-value="\(R.widget)">
		            <input type="hidden" name="value" data-value="\(_last)">
		          </form>
		        </div>
		      </div>
		    </template>
		  </div>
		</w3caria--rover>
		"""
}
