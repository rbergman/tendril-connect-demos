{UserAccount, MeterReadings} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Meter Readings"
  apis: [
    {name: "Users: User External Account ID", path: "user_external_account_id"}
    {name: "Metering: Meter Readings", path: "meter_readings"}
  ]

  action: (env, events) ->
    
    getExternalAccountId = (next) ->
      
      loaded = (model) ->
        next model.data.account["@externalAccountId"]

      options =
        trace: "Get user's external account id"
        oauth: env.oauth

      UserAccount.load(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("loaded", loaded)
    
    getMeterReadings = (externalAccountId) ->

      loaded = (model) ->
        env.locals.model = model
        events.done()

      options =
        trace: "Get user's meter data"
        oauth: env.oauth
        externalAccountId: externalAccountId
        from: "2011-12-30T00:00:00-0000"
        to: "2011-12-31T00:00:00-0000"

      MeterReadings.load(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("loaded", loaded)
    
    # first, get a list of the user's devices
    getExternalAccountId (externalAccountId) ->
      # if successful, make the request for the meter data
      getMeterReadings externalAccountId
