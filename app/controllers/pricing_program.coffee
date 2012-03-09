{PricingProgram} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Pricing Program"
  apis: [{name: "Pricing: Pricing Program", path: "pricing_program"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()
    
    options =
      trace: "Get user's pricing program"
      oauth: env.oauth

    PricingProgram.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
