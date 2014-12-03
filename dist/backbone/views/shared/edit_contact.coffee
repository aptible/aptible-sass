class App.Views.ContactEdit extends Backbone.View

  template: ->
    JST['dist/templates/edit_contact']

  events:
    'click .finish': 'onEditFinish'
    'click .select-user': 'onSelectUser'

  defaults:
    idParam: 'approving_authority_id'
    titleParam: 'approving_authority_title'
    emailParam: 'approving_authority_email'
    nameParam: 'approving_authority_name'
    editClassName: '.edit-approving-authority'

  initialize: (options) ->
    { @idParam, @titleParam, @emailParam, @nameParam, @editClassName } = _.defaults options, @defaults()
    @contacts = App.current_organization_users

  render: ->
    @$el.html(@template()(@renderParams()))
    @$alert = @$('.alert').hide()
    @$errorMessage = @$('.error-message')
    @onEditStart()
    @bindEvents()
    @setupState()
    @

  bindEvents: ->
    @$("#{@editClassName}").click @onEditStart
    @$("input[name=#{@titleParam}]").on 'keyup', @onTitleUpdate

  setupState: ->
    @state = new Backbone.Model(
      @model.pick(@idParam, @titleParam, @emailParam, @nameParam)
    )
    @state.on "change:#{@nameParam}", @onNameChange, @
    @state.on "change:#{@titleParam}", @onTitleChange, @
    @state.on "change:#{@emailParam}", @onEmailChange, @

  renderParams: ->
    { contacts: @contacts, model: @state, helpers: App.Helpers }

  onNameChange: ->
    @$('.contact-name').text(@state.get(@nameParam))

  onTitleChange: ->
    @$('.contact-email').text(@state.get(@titleParam))

  onEmailChange: ->
    src = App.Helpers.gravatar_url @state.get(@emailParam), 48
    @$('.contact-gravatar').attr 'src', src

  onEditStart: ->
    @$el.addClass('editing')
    titleValue = $.trim(@$('input[name="#{@titleParam}"]').val())
    @state.set @titleParam, titleValue

  onEditFinish: ->
    if @state.get(@titleParam) and @state.get(@nameParam)
      @confirmChanges()
    else
      @showError 'Title is required'

  onSelectUser: (e) =>
    uid = $(e.target).data('user-id')
    contact = @contacts.get(uid)
    @state.set @idParam, uid
    @state.set @nameParam, contact.get('name')
    @state.set @emailParam, contact.get('email')

  confirmChanges: ->
    @model.set @state.attributes
    @$el.removeClass 'editing'
    @$alert.hide().removeClass 'animated fadeInLeft'

  onTitleUpdate: (e) =>
    if val = $(e.target).val()
      $.trim $(e.target).val()
      @state.set @titleParam, val

  showError: (message) ->
    @$errorMessage.text message
    @$alert.show().addClass('animated fadeInLeft')
