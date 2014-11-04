class App.Views.Wizard extends Backbone.View
  template: ->
    JST['dist/templates/wizard']

  events:
    'click .ensure-configure-manually': 'on_ensure_configure_manually'
    'click .confirm-configure-manually': 'on_configure_manually'
    'click .nav li a': 'on_tab_click'

  tab_container_class: '.tab-content'
  bind_to: ['render', 'add_step_view', 'on_wizard_complete', 'on_tab_click']
  current_index: 0

  initialize: ->
    _.each @bind_to, (binding) =>
      _.bindAll @, binding

    @config = @initialize_config()
    @steps = @initialize_steps()

    _.each @steps, (step, index) =>
      step.index = index

    @render()

  initialize_config: ->
    {}

  initialize_steps: ->
    []

  render: ->
    $(@el).html(@template()(@render_params()))
    @container = @$(@tab_container_class)

    _.each @steps, @add_step_view
    @load_first_step()
    @

  render_params: ->
    { steps: @steps }

  load_first_step: ->
    @go_to_step @current_index

  add_step_view: (step, index) ->
    @container.append step.render().$el

    step.on 'exit', () =>
      @complete_step index
      @current_index = ++index
      @go_to_step @current_index

    step.on 'complete', @on_wizard_complete

  complete_step: (step_index) ->
    tab = @$('.nav li').eq(step_index).addClass('completed')

  go_to_step: (step_index) ->
    if @steps[step_index]
      tabs = @$('.nav li').removeClass('disabled')
      tabs.eq(step_index).find('a').tab('show')
      tabs.eq(step_index).nextAll().addClass('disabled')
      @steps[step_index].on_enter()

  on_wizard_complete: ->
    @$el
      .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', (=>
        document.location.href = document.location.href
      ))
      .addClass('animated fadeOutLeft')

  on_tab_click: (e)->
    tab = $(e.target)
    console.log "tab clicked, index: #{tab.data('index')}"
    @current_index = parseInt(tab.data('index'), 10)

    return unless typeof tab.data('index') isnt 'undefined' and tab.attr('href')

    content = $(tab.attr('href')).show()
    @go_to_step @current_index
