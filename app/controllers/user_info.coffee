{User} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "User Information"
  apis: [{name: "Users: User Information", path: "user_information"}]

  action: (env, events) ->

    options =
      trace: "Get user's information"
      oauth: env.oauth
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    User.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
