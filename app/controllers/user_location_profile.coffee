{UserLocationProfile} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "User Location Profile"
  apis: [{name: "Users: User Location Profile", path: "user_location_profile"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get user's location profile"
      oauth: env.oauth

    UserLocationProfile.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
