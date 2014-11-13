class App.Models.Base extends Backbone.Model
  initialize: ->
    _.bindAll @, 'save_state'
    @on 'change', @save_state

  save_state: ->
    @history.push @.toJSON()
