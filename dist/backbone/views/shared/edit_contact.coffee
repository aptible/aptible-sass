class App.Views.ContactEdit extends Backbone.View
  template: ->
    JST['dist/templates/edit_contact']

  is_editing: true

  events:
    'click .edit-approving-authority': 'on_edit_start'
    'click .finish': 'on_edit_finish'
    'click .select-user': 'on_select_user'
    'keyup input[name="approving_authority_title"]': 'on_title_update'

  initialize: ->
    _.bindAll @, 'on_title_update', 'on_select_user'

    @contacts = App.current_organization_users

    @state = new Backbone.Model(
      @model.pick('approving_authority_name', 'approving_authority_title',
                  'approving_authority_email', 'approving_authority_id')
    )
    @state.on 'change:approving_authority_name', @on_name_change, @
    @state.on 'change:approving_authority_title', @on_title_change, @
    @state.on 'change:approving_authority_email', @on_email_change, @

  render: ->
    @$el.html(@template()(@render_params()))
    @alert = @$('.alert').hide()
    @error_msg = @$('.error-message')
    @on_edit_start()
    @

  render_params: ->
    { contacts: @contacts, model: @state, helpers: App.Helpers }

  on_name_change: ->
    @$('.contact-name').text(@state.get('approving_authority_name'))

  on_title_change: ->
    @$('.contact-email').text(@state.get('approving_authority_title'))

  on_email_change: ->
    src = App.Helpers.gravatar_url(@state.get('approving_authority_email'), 48)
    @$('.contact-gravatar').attr('src', src)

  on_edit_start: ->
    @$el.addClass('editing')
    @state.set('approving_authority_title', $.trim(@$('input[name="approving_authority_title"]').val()))

  on_edit_finish: ->
    if @state.get('approving_authority_title') && @state.get('approving_authority_name')
      @confirm_changes()
    else
      @error 'Title is required'

  on_select_user: (e)->
    uid = $(e.target).data('user-id')
    contact = @contacts.get(uid)
    @state.set('approving_authority_id', uid)
    @state.set('approving_authority_name', contact.get('name'))
    @state.set('approving_authority_email', contact.get('email'))

  confirm_changes: ->
    @model.set(@state.attributes)
    @$el.removeClass('editing')
    @alert.hide().removeClass('animated fadeInLeft')

  on_title_update: (e)->
    val = $.trim($(e.target).val())
    @state.set 'approving_authority_title', val

  error: (message) ->
    @error_msg.text(message)
    @alert.show().addClass('animated fadeInLeft')

