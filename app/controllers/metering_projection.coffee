{ProjectedConsumption} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Projected Cost & Consumption"
  apis: [{name: "Metering: Projected Cost & Consumption", path: "projected_cost_and_consumption"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()
    
    options =
      trace: "Get user's projected cost & consumption"
      oauth: env.oauth

    ProjectedConsumption.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
