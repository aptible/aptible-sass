class App.Views.UploadsShow extends Backbone.View
  new_upload: (data) ->
    JST['dist/templates/uploads_show'](data)

  initialize: ->
    _.bindAll(@, 'remove')

    @listenTo(@model, 'change:progress', @update_progress)
    @listenTo(@model, 'complete', @remove)

  render: ->
    @$el.html(@new_upload(@model.as_json()))
    @

  update_progress: ->
    console.log "Upload #{@model.get('progress')}% complete"