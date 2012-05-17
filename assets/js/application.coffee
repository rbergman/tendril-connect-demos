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
      $($(this).attr("href")).slideToggle("hidden")

  initDeviceActions = ->
    
    $("a[data-device-cmd]").live "click", (e) ->
      $btn = $(this)
      cmd = $btn.attr("data-device-cmd")
      [type, id, action] = cmd.split "-"
      data = ""
      if action is "data"
        enc = encodeURIComponent
        params = $btn.parent().find("input, textarea, select").map(-> "#{enc $(@).attr('name')}=#{enc $(@).val()}")
        params = [].slice.apply params
        data = "&" + (params.join "&") if params.length > 0
      Tendril.load("/devices/#{type}?ns=#{cmd}&id=#{id}&action=#{action}#{data}", "#{cmd}_content")

  window.Tendril = 

    load: (url, elId) ->
      $deferred = $("#" + elId)
      $deferred.html("<div class='spinner hidden'><img src='/img/spinner.gif'><p/>Loading...</div>")
      $deferred.find(".spinner").delay(400).fadeIn(100)
      done = (html) ->
        $deferred.hide().html(html).fadeIn(100)
        initTracePanels()
      fail = (xhr, status, error) ->
        done "<div class='alert alert-error'>Failed to load content#{if error then ': ' + error else ''}</div>"
      $.get(url).done(done).fail(fail)
  
  # dom ready

  $ ->
  
    initScroll()
    initTracePanels()
    initDeviceActions()
