{UserAccount} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "User Account"
  apis: [{name: "Users: User External Account ID", path: "user_external_account_id"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()

    options =
      trace: "Get user's account information"
      oauth: env.oauth

    UserAccount.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
