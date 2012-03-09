module.exports =

  page: page = (req) ->
    url = require("url").parse req.url
    path = url.pathname.slice(1)
    slash = path.indexOf("/")
    path = path.slice 0, slash if slash > 0
    path or "home"

  messages: require "express-messages-bootstrap"

  format: ->
    (dateTime, format) -> require("moment")(new Date(dateTime)).format(format or "L")

  header: (req) ->
    "#{page(req)}_header"

  title: ->
    "Tendril Connect Demos"

  activeClass: (req) ->
    (name, value) -> if (value or page(req)) is name then "active" else ""

  statusClass: (req) ->
    (xres) ->
      code = xres.statusCode
      body = xres.body
      if code >= 400 or (body and body.indexOf("<failureMessage>") >= 0)
        "alert-error"
      else if code < 300
        "alert-success"
      else
        ""

  request: (req) ->
    req

  session: session = (req) ->
    req.session
  
  user: user = (req) ->
    session(req).user?.data.user
  
  username: (req) ->
    u = user(req)
    if u then "#{u.firstName} #{u.lastName}" else null

  users: -> [
    {name: "kurt.cobain@tendril.com", program: "TOU", usage: "Medium", han: "No"}
    {name: "eddie.vedder@tendril.com", program: "TOU", usage: "Large", han: "No"}
    {name: "scott.weiland@tendril.com", program: "TOU", usage: "Small", han: "No"}
    {name: "layne.staley@tendril.com", program: "Flat", usage: "Medium", han: "No"}
    {name: "chris.cornell@tendril.com", program: "Flat", usage: "Small", han: "No"}
    {name: "zach.rocha@tendril.com", program: "Flat", usage: "Large", han: "No"}
    {name: "billy.corgan@tendril.com", program: "IBR", usage: "Large", han: "No"}
    {name: "thurston.moore@tendril.com", program: "IBR", usage: "Small", han: "No"}
    {name: "black.francis@tendril.com", program: "IBR", usage: "Medium", han: "No"}
    {name: "andrew.wood@tendril.com", program: "Flat", usage: "Medium", han: "Yes"}
    {name: "kim.deal@tendril.com", program: "TOU", usage: "Medium", han: "Yes"}
    {name: "nash.kato@tendril.com", program: "IBR", usage: "Medium", han: "Yes"}
  ]

  deviceActionFailed: (req) ->
    (model) ->
      rstate = model.requestState()
      cstatus = model.completionStatus()
      rstate isnt "Completed" or (cstatus and cstatus isnt "Succeeded")
