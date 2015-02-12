class App.Views.PendingAttachments extends Backbone.View
  new_upload: (data) ->
    JST['dist/templates/pending_upload'](data)

  initialize: ->
    _.bindAll(@, 'render', 'add_upload', 'on_start')

    @listenTo @model, 'start', @on_start
    @listenTo @model, 'add', @add_upload
    @listenTo @model, 'remove', @render

  render: ->
    @$el.html('').addClass('empty')
    @model.each @add_upload

  add_upload: (upload) ->
    @$el.removeClass('empty')
    @$el.prepend @new_upload(upload.as_json())

  on_start: ->
    @$el.addClass('uploading')