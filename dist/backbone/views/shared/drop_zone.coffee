class App.Views.DropZone extends Backbone.View
  events:
    dragenter: 'on_dragover'
    dragleave: 'on_dragout'
    drop: 'dragend'
    dragend: 'dragend'

  initialize: ->
    _.bindAll(@, 'on_dragover', 'on_dragout', 'on_document_dragover', 'on_document_dragout', 'dragend')
    $(document).on 'dragover', @on_document_dragover
    $(document).on 'dragleave', @on_document_dragout
    $(document).on 'dragend drop', @dragend

    @render()

  render: ->
    @

  dragend: ->
    @on_dragout()
    @on_document_dragout()

  on_document_dragover: ->
    $("a[href='#attachments_tab']").tab('show')

    @$el.addClass('dragging')

  on_document_dragout: ->
    @$el.removeClass('dragging')

  on_dragover: ->
    @$el.addClass('drag-over')

  on_dragout: ->
    @$el.removeClass('drag-over')

  on_close: ->
    $(document).off 'dragenter', @on_document_dragover
    $(document).off 'dragleave', @on_document_dragout
    $(document).off 'dragend drop', @dragend
