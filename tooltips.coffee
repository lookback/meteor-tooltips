# Defaults

Tooltip =
	text: false
	css: {top: 0, left: 0}
	direction: 'tooltip--top'

dep = new Tracker.Dependency()
offset = [10, 10]

DIRECTION_MAP =
	'n': 'tooltip--top'
	's': 'tooltip--bottom'
	'e': 'tooltip--right'
	'w': 'tooltip--left'

# Tooltip functions

getTooltip = ->
	dep.depend()
	return Tooltip

setTooltip = (what, where) ->
	Tooltip.css = where if where
	Tooltip.text = what
	dep.changed()

setPosition = (position, direction) ->
	Tooltip.css = position
	Tooltip.direction = DIRECTION_MAP[direction] if direction
	dep.changed()

hideTooltip = ->
	setTooltip false

# Positioning

center = (args) ->
	middle = args[0] + args[1] / 2
	middle - args[2] / 2

horizontally = ($el, $reference) ->
	[$reference.offset().left, $reference.outerWidth(), $el.outerWidth()]

vertically = ($el, $reference) ->
	[$reference.offset().top, $reference.outerHeight(), $el.outerHeight()]

# Exports

Tooltips =
	set: setTooltip
	get: getTooltip
	hide: hideTooltip

# Template helpers

Template.tooltips.helpers
	display: ->
		tip = getTooltip()

		if tip.text then 'show' else 'hide'

	position: ->
		css = getTooltip().css
		return "position: absolute; top: #{css.top}px; left: #{css.left}px"

	content: ->
		getTooltip().text

	direction: ->
		getTooltip().direction

# Init

Meteor.startup ->

	$(document).on 'mouseover', '[data-tooltip]', (evt) ->
		$el = $(this)
		setTooltip $el.data 'tooltip'

		Tracker.afterFlush ->
			direction = $el.data('tooltip-direction') or 'n'
			$tooltip = $(".tooltip")

			position = $el.offset()
			offLeft = $el.data('tooltip-left') or offset[0]
			offTop = $el.data('tooltip-top') or offset[1]

			position.top = switch direction
				when 'w', 'e' then center vertically $tooltip, $el
				when 'n' then position.top - $tooltip.outerHeight() - offTop
				when 's' then position.top + $el.outerHeight() + offTop

			position.left = switch direction
				when 'n', 's' then center horizontally $tooltip, $el
				when 'w' then position.left - $tooltip.outerWidth() - offLeft
				when 'e' then position.left + $el.outerWidth() + offLeft

			setPosition(position, direction)

	$(document).on 'mouseout', '[data-tooltip]', hideTooltip
