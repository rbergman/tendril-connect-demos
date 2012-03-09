{GreenButton} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Green Button Data Download"
  apis: [{name: "Green Button: Download Data", path: "greenbutton"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get user's Green Button interval data"
      oauth: env.oauth
      from: "12/30/2011"
      to: "12/31/2011"
      resolution: "HOURLY"

    GreenButton.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
