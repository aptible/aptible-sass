window.AptibleSassScripts = {}

AptibleSassScripts.adjustContentHeight = ->
  # First, push the footer down by setting the min-height
  # of the main yield block
  minHeight = $(window).height() -
              $('nav').height() -
              $('#footer-color-box').height() - 1
  $('#main-yield-wrapper').css("min-height", minHeight)

AptibleSassScripts.fetchStatusPage = ->
  window.fetchStatusPage
    pageId: "fmwgqnbnbc4r"
    successCallback: (data) ->
      # add a tooltip with the current status description
      $("#status-link").tooltip
        placement: "bottom"
        title: data.status.description

      # ... and turn the light on
      switch data.status.indicator
        when "none"
          $("#status-circle").addClass("green")
        when "minor"
          $("#status-circle").addClass("yellow")
        when "major", "critical"
          $("#status-circle").addClass("red")
        else
          return # TODO: throw an error and log if the switch falls through

$(document).ready ->
  _.defer ->
    AptibleSassScripts.adjustContentHeight()
    AptibleSassScripts.fetchStatusPage()

$(window).resize ->
  AptibleSassScripts.adjustContentHeight()
