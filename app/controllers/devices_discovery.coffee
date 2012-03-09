{Devices} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "User's Devices"
  apis: [{name: "Devices: List User's Devices", path: "list_users_devices"}]

  action: (env, events) ->
    
    loaded = (model) ->
      env.locals.model = model
      events.done()
    
    options =
      trace: "List user's devices"
      oauth: env.oauth
      includeExtendedProperties: true

    Devices.load(options)
      .on("trace", events.trace)
      .on("error", events.fail)
      .on("loaded", loaded)
