{Consumption} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Cost & Consumption"
  apis: [{name: "Metering: Cost & Consumption", path: "cost_and_consumption"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get user's cost & consumption"
      oauth: env.oauth
      from: "2011-07-01T00:00:00-0000"
      to: "2011-12-31T00:00:00-0000"

    Consumption.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
