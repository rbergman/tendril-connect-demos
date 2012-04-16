#= require bootstrap.min
#= require jquery.flot
#= require greenbutton
  
do ->
  
  # fix sub nav on scroll
  initScroll = ->
  
    $win = $(window)
    $nav = $(".subnav")
    navTop = $nav.length and $nav.offset().top - 40
    isFixed = 0
  
    processScroll = ->
      scrollTop = $win.scrollTop()
      if scrollTop >= navTop and not isFixed
        isFixed = 1
        $nav.addClass("subnav-fixed")
      else if scrollTop <= navTop and isFixed
        isFixed = 0
        $nav.removeClass "subnav-fixed"
  
    processScroll()
  
    $win.on "scroll", processScroll
  
  initTracePanels = ->

    $("a[data-toggle='trace-panel']").click (e) ->
      e.preventDefault()
      $($(e.target).attr("href")).slideToggle("hidden")

  window.Tendril = 

    load: (url) ->
      $deferred = $("#deferred-content")
      $("#spinner").delay(400).fadeIn(100)
      done = (html) ->
        $deferred.hide().html(html).fadeIn(100)
        initTracePanels()
        # clearInterval timer
      fail = (xhr, status, error) ->
        done "<div class='alert alert-error'>Failed to load content#{if error then ': ' + error else ''}</div>"
      $.get(Tendril.deferred).done(done).fail(fail)
  
  # dom ready

  $ ->
  
    initScroll()
    initTracePanels()
