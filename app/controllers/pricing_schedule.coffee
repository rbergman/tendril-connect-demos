{PricingSchedule} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Pricing Schedule"
  apis: [{name: "Pricing: Pricing Schedule", path: "pricing_schedule"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()
    
    options =
      trace: "Get user's pricing schedule"
      oauth: env.oauth
      from: "2011-12-30T00:00:00-0000"
      to: "2011-12-31T00:00:00-0000"

    PricingSchedule.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
