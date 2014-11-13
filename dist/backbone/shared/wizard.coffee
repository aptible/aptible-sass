class App.Views.WizardOld extends Backbone.View
  template: JST['dist/templates/wizard']
  events:
    'click .ensure-configure-manually': 'on_ensure_configure_manually'
    'click .confirm-configure-manually': 'on_configure_manually'
    'click .nav-tabs li a': 'on_tab_click'

  initialize: ->
    _.bindAll @, 'render', 'add_step_view', 'on_wizard_complete', 'on_configure_manually'

    @config = new Backbone.Model
      current_user: App.current_user
      ssh_key: new App.Models.SSHKey({ user_id: App.current_user.get('id') })
      app: new App.Models.App({ account_id: gon.account_id })
      db: new App.Models.Database({ account_id: gon.account_id, status: 'provisioning' })

    @steps = [
      new App.Views.SSHKeysNew
        id: 'ssh'
        model: @config.get('ssh_key')
        title: 'Save Your SSH Key'
      new App.Views.AppsNew
        id: 'app'
        title: 'Create an App'
        model: @config.get('app')
      new App.Views.DatabasesNew
        id: 'db'
        title: 'Create a Database'
        model: @config.get('db')
      new App.Views.AccountsConfigure
        id: 'config'
        title: 'Configure and Deploy'
        model: @config
    ]
    @render()

  render: ->
    $(@el).html(@template({ steps: @steps }))
    @container = @$(".tab-content")

    _.each @steps, @add_step_view
    @load_first_step()
    @

  load_first_step: ->
    if @config.get('current_user').get('ssh_keys').length > 0
      @complete_step(0)
      @go_to_step 1
    else
      @go_to_step 0

  add_step_view: (step, index) ->
    @container.append step.render().$el

    step.on 'exit', () =>
      @complete_step index
      @go_to_step ++index

    step.on 'complete', @on_wizard_complete

  complete_step: (step_index) ->
    tab = $('.nav-tabs li').eq(step_index).addClass('completed')
    tab.find('a').replaceWith("<span>#{@steps[step_index].title}</span>")

  go_to_step: (step_index) ->
    if @steps[step_index]
      @$('.nav-tabs li').eq(step_index).find('a').tab('show')
      @steps[step_index].on_enter()

  on_wizard_complete: ->
    @$el
      .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', (=>
        document.location.href = document.location.href
      ))
      .addClass('animated fadeOutLeft')

  on_ensure_configure_manually: (e)->
    e.preventDefault()
    @modal = @$('.confirm-dismiss').modal()

  on_configure_manually: (e)->
    e.preventDefault()
    @modal.modal('hide') if @modal
    window.analytics.identify({ guide_status: 'dismissed' })
    @on_wizard_complete()

  on_tab_click: (e) ->
    e.preventDefault()

