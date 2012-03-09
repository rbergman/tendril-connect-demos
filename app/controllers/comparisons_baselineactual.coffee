{BaselineActualConsumption} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Cost & Consumption Comparison: Baseline and Actual"
  apis: [{name: "Comparisons: Cost & Consumption Comparisons, Baseline and Actual", path: "cost_and_consumption_comparison_baselineactual"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get baseline and actual cost & consumption"
      oauth: env.oauth

    BaselineActualConsumption.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
