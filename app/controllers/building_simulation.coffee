{BuildingModelSimulation} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Run Building Model Simulation"
  apis: [
    {name: "Building Model: Create Building Model Simulation", path: "create_building_model_simulation"}
    {name: "Building Model: Query Building Model Simulation", path: "query_building_model_simulation"}
  ]

  action: (env, events) ->

    ready = (model, elapsed) ->
      env.locals.model = model
      env.locals.elapsed = elapsed
      events.done()

    options =
      trace: "Run building model simulation"
      oauth: env.oauth
      from: "2011-01-01T00:00:00-0000"
      to: "2011-12-31T00:00:00-0000"
      resolution: "YEAR"

    new BuildingModelSimulation().invoke(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("ready", ready)
