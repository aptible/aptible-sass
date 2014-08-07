$(document).ready ->
  $.fn.extend
    orgSelectDropdown: ->
      this.each ->
        dropdown = $(this)

        dropdown.on 'click', (e) ->
          e.preventDefault()
          link = $(e.target)
          orgHref = link.data('org-href')

          $.ajax
            url: link.attr('href')
            type: 'PUT'
            data: { organization_url: orgHref }
            success: ->
              if typeof Turbolinks isnt 'undefined'
                Turbolinks.visit document.location.href
              else
                document.location.href = document.location.href

  $('.current-organization .dropdown-menu a.org-name').orgSelectDropdown()