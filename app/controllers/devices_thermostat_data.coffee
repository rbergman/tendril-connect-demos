{UserLocation, Devices, ThermostatProxy} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Set Thermostat Data"
  apis: [
    {name: "Users: User Location", path: "user_location"}
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

    setThermostatData = (locationId) ->
      
      deviceId = env.request.query.id
      mode = env.request.query.mode
      setpoint = env.request.query.setpoint

      ready = (model, elapsed) ->
        env.locals.model = model
        env.locals.elapsed = elapsed
        events.done()

      options =
        trace: "Set mode for smart plug with id '#{deviceId}'"
        mode: mode
        setpoint: setpoint
        oauth: env.oauth

      new ThermostatProxy(deviceId, locationId).set(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("ready", ready)

    # first, get the default location id for the current user
    getLocation (locationId) ->
      # then use the location information to control the device
      setThermostatData locationId
