{UserLocation, Devices, ThermostatProxy} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Get Thermostat Data"
  apis: [
    {name: "Users: User Location", path: "user_location"}
    {name: "Devices: List User's Devices", path: "list_users_devices"}
    {name: "Devices: Create Device Action", path: "create_device_action"}
    {name: "Devices: Query Device Action", path: "query_device_action"}
  ]

  action: (env, events) ->
    
    getLocation = (next) ->
      
      loaded = (model) ->
        next model.id()

      options =
        trace: "Get user's default location"
        oauth: env.oauth
      
      UserLocation.load(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("loaded", loaded)

    getDevices = (next) ->
      
      loaded = (model) ->
        next model.devices()

      options =
        trace: "List user's devices"
        oauth: env.oauth

      Devices.load(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("loaded", loaded)

    getThermostatData = (device, locationId) ->
      
      env.locals.device = device

      ready = (model, elapsed) ->
        env.locals.model = model
        env.locals.elapsed = elapsed
        events.done()

      options =
        trace: "Get thermostat data for #{device.name} (#{device.marketingName})"
        oauth: env.oauth

      new ThermostatProxy(device.deviceId, locationId).get(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("ready", ready)

    # first, get the default location id for the current user
    getLocation (locationId) ->
      # next, get a list of the user's devices
      getDevices (devices) ->
        # then, to make this easy, pick the first thermostat we can find
        thermostats = (device for device in devices when device.category is "Thermostat")
        if thermostats.length > 0
          getThermostatData thermostats[0], locationId
        else
          events.fail new Error "The current user does not have a thermostat"
