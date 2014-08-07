visit_url = (url) ->
  if typeof Turbolinks isnt 'undefined'
    Turbolinks.visit url
  else
    document.location.href = url

$(document).ready ->
  $.fn.extend
    orgSelectDropdown: (options) ->
      this.each ->
        dropdown = $(this)

        dropdown.on 'click', (e) ->
          e.preventDefault()
          link = $(e.target)
          orgHref = link.data('org-href')
          returnHref = link.data('return-to')

          $.ajax
            url: link.attr('href')
            type: 'PUT'
            data: { organization_url: orgHref }
            success: ->
              visit_url returnHref

  $('.current-organization .dropdown-menu a.org-name').orgSelectDropdown()