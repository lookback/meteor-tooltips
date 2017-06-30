if Meteor.isClient

  Template.body.created = ->
    Session.setDefault 'show', true
    Session.set 'counter', 1

  Template.body.helpers(
    show: ->
      Session.get 'show'

    counter: ->
      Session.get 'counter'
  )

  Template.body.events(
    'click [data-counter]': (evt, tmpl) ->
      count = Session.get 'counter'
      Session.set 'counter', count + 1

    'click [data-toggle]': (evt, tmpl) ->
      evt.preventDefault()
      state = Session.get 'show'
      Session.set 'show', !state

      Meteor.setTimeout ->
        Session.set 'show', true
      , 3000

    'click #show-tooltip': ->
      $('#manual-tooltip').trigger('tooltips:show')

    'click #hide-tooltip': ->
      $('#manual-tooltip').trigger('tooltips:hide')

    'click #toggle-tooltip': ->
      $('#manual-tooltip').trigger('tooltips:toggle')
  )
