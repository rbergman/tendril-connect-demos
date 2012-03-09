{Devices, DeviceConsumption} = require "../lib/sdk"

module.exports = require("./simple_controller")
  caption: "Device Cost & Consumption"
  apis: [
    {name: "Devices: List User's Devices", path: "list_users_devices"}
    {name: "Devices: Cost & Consumption for Single Device", path: "cost_and_consumption_single_device"}
  ]

  action: (env, events) ->

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

    getConsumption = (device) ->

      loaded = (model) ->
        env.locals.model = model
        events.done()

      options =
        trace: "Get device cost & consumption for #{device.name} (#{device.marketingName}, #{device.category})"
        oauth: env.oauth
        deviceId: device.deviceId
        resolution: "DAILY"
        from: "2012-01-24T00:00:00-0000"
        to: "2012-01-31T00:00:00-0000"
        includeExtendedProperties: true

      DeviceConsumption.load(options)
        .on("trace", events.trace)
        .on("error", events.fail)
        .on("loaded", loaded)

    # first, get a list of the user's devices
    getDevices (devices) ->
      # then, to make this easy, pick the first smart plug we can find
      plugs = (device for device in devices when device.marketingName is "ThinkEco Modlet")
      if plugs.length > 0
        getConsumption plugs[0]
      else
        events.fail new Error "The current user does not appear to have any smart plugs to query or control"
