{UserLocation} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "User Location"
  apis: [{name: "Users: User Location", path: "user_location"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get user's default location"
      oauth: env.oauth

    UserLocation.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
