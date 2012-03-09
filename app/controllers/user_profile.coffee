{UserProfile} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "User Profile"
  apis: [{name: "Users: User Profile", path: "user_profile"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get user's profile"
      oauth: env.oauth

    UserProfile.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
