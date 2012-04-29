{UserLocation, Devices, SmartPlugProxy} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Smart Plug Status"
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

    getSmartPlugData = (device, locationId) ->

      env.locals.device = device

      ready = (model) ->
        env.locals.model = model
        events.done()

      options =
        trace: "Get smart plug data for #{device.name} (#{device.marketingName})"
        oauth: env.oauth

      new SmartPlugProxy(device.deviceId, locationId).get(options)
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
          plug = devices.deviceById deviceId
        else
          # else if none was specified, go with the first of its type
          plug = devices.firstDeviceByCategory "Load Control"
        if not plug
          events.fail new Error "No usable smart plug found"
        else
          getSmartPlugData plug, locationId
