if Meteor.isClient

  Template.body.created = ->
    Session.setDefault 'show', true

  Template.body.helpers(
    show: ->
      Session.get 'show'
  )

  Template.body.events(
    'click [data-toggle]': (evt, tmpl) ->
      evt.preventDefault()
      state = Session.get 'show'
      Session.set 'show', !state

      Meteor.setTimeout ->
        Session.set 'show', true
      , 3000

    'click #show-tooltip': ->
      $('#manual-tooltip').trigger('showTooltip')

    'click #hide-tooltip': ->
      $('#manual-tooltip').trigger('hideTooltip')

    'click #toggle-tooltip': ->
      $('#manual-tooltip').trigger('toggleTooltip')
  )
