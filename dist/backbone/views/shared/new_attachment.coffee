class App.Views.AttachmentsNew extends Backbone.View
  events:
    'click .choose-files': 'choose_files'

  uploads_remaining: 0

  initialize: (options)->
    _.bindAll(@, 'on_add', 'on_success', 'on_progress', 'choose_files')
    @pending_uploads = []
    @pending_uploads.length = 0
    @dropzone = options.dropzone
    @autoupload = !!options.autoupload
    @uploads = options.uploads || new App.Models.UploadCollection()

  render: ->
    @$el.fileupload
      autoUpload: @autoupload
      url: @url()
      dataType: 'json'
      type: 'post'
      dropZone: @dropzone.$el
      add: @on_add
      success: @on_success
      progress: @on_progress

    @

  trigger_upload: (path) ->
    @$('form').attr('action', path)

    return @trigger('uploads_complete') if @pending_uploads.length is 0

    @uploads_remaining = @pending_uploads.length

    _.each @pending_uploads, (data) ->
      data.submit()

  on_add: (e, data) ->
    if @autoupload
      data.submit()
    else
      @pending_uploads.push(data)

    new_upload = new App.Models.Upload({ file: data.files[0] })
    @uploads.add new_upload
    @trigger('add', new_upload)

  on_success: (attachment_data) ->
    window.uploadz = @uploads
    upload = @uploads.get(attachment_data.file_name.replace(/\s/ig, '_'))

    upload.trigger('complete')
    attachment_data.preview_url = upload.get_preview_url()

    @uploads.remove(upload)
    @model.add(attachment_data)

    @uploads_remaining = @uploads_remaining - 1
    @trigger('uploads_complete') if @uploads_remaining is 0

  on_progress: (e, data) ->
    progress = parseInt(data.loaded / data.total * 100, 10)
    console.log("#{progress}% complete")
    #@current_upload.set('progress', progress)

  url: ->
    @$('form').attr('action')

  choose_files: ->
    @$('form input').click()
