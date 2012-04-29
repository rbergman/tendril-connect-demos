{UserLocation, Devices, ThermostatProxy} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Thermostat Status"
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
        next model

      options =
        trace: "List user's devices"
        oauth: env.oauth

      Devices.load(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("loaded", loaded)

    getThermostatData = (device, locationId) ->
      
      env.locals.device = device

      ready = (model) ->
        env.locals.model = model
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
        deviceId = env.request.query.id
        if deviceId
          # if a deviceId was specified, choose that if it exists
          thermostat = devices.deviceById deviceId
        else
          # else if none was specified, go with the first of its type
          thermostat = devices.firstDeviceByCategory "Thermostat"
        if not thermostat
          events.fail new Error "No usable thermostat found"
        else
          getThermostatData thermostat, locationId
