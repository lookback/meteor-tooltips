# Reactive tooltips for Meteor

Forget about adding clunky Bootstrap packages. The `lookback:tooltips` package provides tooltips "The Meteor Way" – the reactive way! Barebones, minimal and functional.

**Demo:** [tooltips.meteor.com](http://tooltips.meteor.com/) *(code available in the `example` directory).*

## Install

```bash
meteor add lookback:tooltips
```

## Usage

You can now use the `tooltips` (singleton) template in your layouts/templates.

```html
<template name="main">
  <p>Some content.</p>

  {{ > tooltips }}
</template>
```

### Basic

Attach a tooltip to an element with the `data-tooltip` data attribute:

```html
<template name="main">
<p>Some content.</p>

<p>
  <button data-tooltip="I'm a tooltip!">A tooltip trigger</button>
</p>

{{ > tooltips }}
</template>
```

The tooltip will show when hovering over the button.

### Direction

You may specify the **direction** of the tooltip around the element as well, with the `data-tooltip-direction` attribute.

```html
<template name="main">
<p>Some content.</p>

<p>
<button data-tooltip="I'm a tooltip to the left!" data-tooltip-direction="w">A tooltip trigger</button>
</p>

{{ > tooltips }}
</template>
```

The `data-tooltip-direction` attribute takes these values:

- `n` - Top *(default)*
- `s` - Bottom
- `e` - Left
- `w` - Right

### Offsets

Tooltips support **offsets** from their element when you specify the `data-tooltip-top` and `data-tooltip-left` data attributes on the element.

```html
<template name="main">
<p>Some content.</p>

<p>
<button data-tooltip="I'm a tooltip!" data-tooltip-top="50">A tooltip trigger</button>
</p>

{{ > tooltips }}
</template>
```
The tooltip in the example above will be offset 50 pixels *to the north* (upwards on screen).

Both attributes takes positive and negative numbers, intepreted as **pixels**.

## Styling

This package does not bundle any CSS styles for the tooltips – it's up to you to style them. The only styles that are included are inlined on the tooltip element itself:

```html
<div class="tooltip tooltip--top" style="position: absolute; top: 100px; left: 100px;">
<div class="inner">Content</div>
</div>
```

## Helper classes

The package adds some helper classes to the tooltip element, for styling and transitioning.

The main tooltip element has these classes:

- `tooltip`
- `tooltip--top`, `tooltip--bottom`, `tooltip--left`, `tooltip--right` – For the tooltip direction. Usable for adding CSS arrows and other stuff to a tooltips, depending on its direction. *Defaults to* `tooltip--top`.

The content wrapper has the `inner` class. Usable for separate styling as well as for transitioning.

When hovering over the triggering element, a `show` class will be added to the main tooltip element. When the tooltip is inactive, it'll have the `hide` class.

**You must style the `show` and `hide` classes.**

Commonly, you would give the tooltip element these basic styles (see the `_tooltip.scss` file in the `example` folder):

```scss
.tooltip {
  z-index: 1001;
  pointer-events: none;
  transition: opacity .1s ease-out;
  opacity: 0;

  &.hide {
    opacity: 0;
  }

  &.show {
    opacity: 1;
  }
}
```

## Disabling for other viewports

It's possible to completely disable the tooltips, or just for a certain viewport. By setting the `Tooltips.disable` option (defaults to `false`), you can pass in `true` to disable all tooltips, or a [`matchMedia`](https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia) string which disables all tooltips for that viewport.

```js
# Disable for all
Tooltips.disable = true

# Disable for devices/browsers over 500 px in width
Tooltips.disable = '(min-width: 500px)'

# Disable for devices/browser below 400 px in width
Tooltips.disable = '(max-width: 400px)'
```

You can also disable individual tooltips directly from the markup, by setting the `data-tooltip-disable` attribute:

```html
<!-- Disables *this* tooltip for browsers below 400px in width. -->
<button data-tooltip="I'm a tooltip!" data-tooltip-disable="(max-width: 400px)">A tooltip trigger</button>
```

## Version history

- `0.2.2` - Export `setPosition` function. *Experimental:* Allow removal of tooltips when element is removed.
- `0.2.1` - Fix rounding errors when positioning.
- `0.2.0` - Expose public API namespace (`Tooltips`).
- `0.1.2` - Use `mouseover` event instead of `mouseenter`.
- `0.1.1` - Require Meteor 0.9.3.
- `0.1.0` - Initial publish.

## Contributions

Contributions are welcome. Please open issues and/or file Pull Requests.

***

Made by [Lookback](http://lookback.io).
