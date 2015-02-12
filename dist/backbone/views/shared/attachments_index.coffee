class App.Views.AttachmentsIndex extends Backbone.View
  uploads: {}
  events:
    'click .delete-attachment' : 'remove_attachment'

  new_attachment: (data)->
    JST['dist/templates/attachments_show'](data)

  initialize: (options)->
    _.bindAll(@, 'add_attachment', 'remove_attachment', 'upload_started')

    @dropzone = new App.Views.DropZone el: @$el
    @newAttachment = new App.Views.AttachmentsNew(model: @model, dropzone: @dropzone, autoupload: true)
    @container = @$('.attachments-list')

    @listenTo(@model, 'add', @add_attachment)
    @listenTo(@model, 'all', @event_triggered)
    @listenTo(@newAttachment, 'add', @upload_started)

    @render()

  render: ->
    @newAttachment.setElement(@$('.upload-attachments'))
    @newAttachment.render()

    @dropzone.setElement(@$el)

    @

  add_attachment: (attachment, attachmentList)->
    @container.prepend @new_attachment(attachment.toJSON())

  remove_attachment: (e) ->
    $target = $(e.target)
    attachment_id = $target.attr('data-attachment-id')
    @model.get(attachment_id).destroy()
    container = $target.parents('.attachment-item').fadeTo 250, 0, =>
      container.remove()

  event_triggered: (event_name, model) ->
    if event_name is 'add' or event_name is 'remove'
      @update_attachment_count()

  update_attachment_count: ->
    $('.attachment-count').text(@model.length)

  upload_started: (upload)->
    @uploads[upload.cid] = new App.Views.UploadsShow({ model: upload })
    @container.prepend(@uploads[upload.cid].render().$el)

  upload_success: (upload) ->
    @uploads[upload.cid].remove()

  on_close: ->
    @dropzone.close()
    @newAttachment.close()