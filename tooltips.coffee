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

_showTooltip = (e, $el) ->
	$el = $el or $(@)
	viewport = $el.data 'tooltip-disable'

	if viewport and _.isString(viewport)
		mq = window.matchMedia(viewport)
		return false if mq.matches

	content = if selector = $el.data 'tooltip-element'
		$target = $(selector)
		$target.length and $target.html()
	else
		$el.data('tooltip')

	setTooltip content
	setPosition(top: 0, left: 0)

	Tracker.afterFlush ->
		direction = $el.data('tooltip-direction') or 'n'
		$tooltip = $(".tooltip")

		position = $el.offset()
		offLeft = $el.data('tooltip-left')
		offTop = $el.data('tooltip-top')

		if _.isUndefined(offLeft)
			offLeft = 0
		else
			hasOffsetLeft = true

		if _.isUndefined(offTop)
			offTop = 0
		else
			hasOffsetTop = true

		position.top = switch direction
			when 'w', 'e' then (center vertically $tooltip, $el) + offTop
			when 'n' then position.top - $tooltip.outerHeight() - (if hasOffsetTop then offTop else offset[1])
			when 's' then position.top + $el.outerHeight() + (if hasOffsetTop then offTop else offset[1])

		position.left = switch direction
			when 'n', 's' then (center horizontally $tooltip, $el) + offLeft
			when 'w' then position.left - $tooltip.outerWidth() - (if hasOffsetLeft then offLeft else offset[0])
			when 'e' then position.left + $el.outerWidth() + (if hasOffsetLeft then offLeft else offset[0])

		setPosition(position, direction)


_toggleTooltip = ->
	if getTooltip().text
		hideTooltip()
	else
		_showTooltip null, $(@)

# Positioning

center = (args) ->
	middle = args[0] + args[1] / 2
	middle - Math.round(args[2] / 2)

horizontally = ($el, $reference) ->
	[$reference.offset().left, $reference.outerWidth(), $el.outerWidth()]

vertically = ($el, $reference) ->
	[$reference.offset().top, $reference.outerHeight(), $el.outerHeight()]

# Exports

Tooltips =
	disable: false
	set: setTooltip
	get: getTooltip
	hide: hideTooltip
	setPosition: setPosition

# Enable/disable for viewports

Template.tooltips.onCreated ->
	@disabled = new ReactiveVar(Tooltips.disable)

	if Tooltips.disable and _.isString(Tooltips.disable)
		mq = window.matchMedia(Tooltips.disable)
		@disabled.set(mq.matches)

		mq.addListener (changed) =>
		  @disabled.set(changed.matches)


# Template helpers

Template.tooltips.helpers
	display: ->
		tip = getTooltip()

		if Template.instance().disabled.get() is true
			return 'hide'

		if tip.text then 'show' else 'hide'

	position: ->
		css = getTooltip().css
		return "position: absolute; top: #{css.top}px; left: #{css.left}px"

	content: ->
		getTooltip().text

	direction: ->
		getTooltip().direction

# Init

Template.tooltip.onRendered ->

	this.lastNode._uihooks =
		insertElement: (node, next) ->
			next.parentNode.insertBefore(node, next)

		moveElement: (next) ->
			Tooltips.hide()
			next.parentNode.insertBefore(node, next)

		removeElement: (node) ->
			Tooltips.hide()
			node.parentNode.removeChild(node)

Meteor.startup ->

	$(document).on 'mouseover', '[data-tooltip]:not([data-tooltip-trigger]), [data-tooltip-element]:not([data-tooltip-trigger]), [data-tooltip-trigger="hover"]', _showTooltip
	$(document).on 'mouseout', '[data-tooltip]:not([data-tooltip-trigger]), [data-tooltip-element]:not([data-tooltip-trigger]), [data-tooltip-trigger="hover"]', hideTooltip
	$(document).on 'click', '[data-tooltip-trigger="click"]', _toggleTooltip
	$(document).on 'focus', '[data-tooltip-trigger="focus"]', _showTooltip
	$(document).on 'blur', '[data-tooltip-trigger="focus"]', hideTooltip
	$(document).on 'tooltips:show', '[data-tooltip-trigger="manual"]', _showTooltip
	$(document).on 'tooltips:hide', '[data-tooltip-trigger="manual"]', hideTooltip
	$(document).on 'tooltips:toggle', '[data-tooltip-trigger="manual"]', _toggleTooltip
