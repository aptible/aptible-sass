class App.Views.WizardStep extends Backbone.View
  className: 'tab-pane fade'
  initialize: (options) ->
    @title = options.title
    @config = options.config
    _.bindAll @, 'on_submit', 'on_change', 'on_submit', 'on_error', 'on_exit', 'detect_enter', 'on_enter', 'render'
    @after_initialize()

  after_initialize: ->
  render: ->
    @$el.html(@template()(@render_params()))
    @submit_btn = @$('button[type="submit"]').on 'click', @on_submit
    @alert = @$('.alert').hide()
    @error_msg = @$('.error-message')
    @after_render()
    @

  after_render: ->
  render_params: ->
    @

  on_change: (e) ->
    $target = $(e.target)
    val = $target.val()
    key = $target.attr('id') || $target.attr('name')

    if key
      @model.set key, val

  on_submit: ->
    if @model.isValid()
      @model.save(@model.attributes, @submit_params())
    else
      @on_error(@model.errors.join(', '))

  submit_params: ->
    { patch: true, error: @on_error, success: _.bind(@exit, @) }

  on_error: (message, xhr) ->
    if xhr && xhr.responseJSON && xhr.responseJSON.message
      message = xhr.responseJSON.message
    else if $.type(message) != 'string'
      message = 'Something went wrong'

    @error_msg.text(message)
    @alert.show().addClass('animated fadeInLeft')

  exit: ->
    @$el
      .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', @on_exit)
      .addClass('animated fadeOutLeft')

  on_exit: ->
    @trigger 'exit'
    @$el.hide().removeClass('animated fadeOutLeft')

  detect_enter: (e) ->
    code = e.which || e.keycode
    @submit_btn.click() if code == 13

  on_enter: ->
    @$('input, textarea').first().focus()

  validate: ->
    true