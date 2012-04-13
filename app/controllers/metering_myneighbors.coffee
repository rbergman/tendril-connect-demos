{NeighborsConsumption} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Cost & Consumption: My Neighbors"
  apis: [{name: "Comparisons: Cost & Consumption Comparisons, to My Neighbors", path: "cost_and_consumption_comparison_myneighbors"}]

  action: (env, events) ->

    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get cost & consumption comparison with user's neighbors"
      oauth: env.oauth

    NeighborsConsumption.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
