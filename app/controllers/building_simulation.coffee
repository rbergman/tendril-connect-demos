{BuildingModelSimulation} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Run Building Model Simulation"
  apis: [
    {name: "Building Model: Create Building Model Action", path: "create_building_model_action"}
    {name: "Building Model: Query Building Model Action", path: "query_building_model_action"}
  ]

  action: (env, events) ->

    ready = (model, elapsed) ->
      env.locals.model = model
      env.locals.elapsed = elapsed
      events.done()

    options =
      trace: "Run building model simulation"
      oauth: env.oauth
      from: "2012-01-24T00:00:00-0000"
      to: "2012-01-31T00:00:00-0000"
      resolution: "HOUR"

    new BuildingModelSimulation().invoke(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("ready", ready)
