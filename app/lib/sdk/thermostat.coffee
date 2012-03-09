{DeviceAction, DeviceData} = require "./device_action"

exports.SetThermostatDataRequest = class SetThermostatDataRequest extends DeviceAction
  
  @schema
    "setThermostatDataRequest":
      "@xmlns": "string"
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "data":
        "setpoint": "float"
        "mode": "string"
        "temperatureScale": "string"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "setThermostatDataRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
        "data":
          "setpoint": options.setpoint or 70
          "mode": options.mode or "Heat"
          "temperatureScale": options.temperatureScale or "Fahrenheit"
    super options

exports.GetThermostatDataRequest = class GetThermostatDataRequest extends DeviceAction
  
  @schema
    "getThermostatDataRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "result":
        "setpoint": "float"
        "mode": "string"
        "temperatureScale": "string"
        "currentTemp": "float"
        "activeLoadControlEvent": "boolean"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "getThermostatDataRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
    super options

  constructor: (data, self) ->
    super data, self
  
  setpoint: ->
    @result().setpoint if @result()

  mode: ->
    @result().mode if @result()

  temperatureScale: ->
    @result().temperatureScale if @result()
  
  currentTemp: ->
    @result().currentTemp if @result()
  
  activeLoadControlEvent: ->
    @result().activeLoadControlEvent if @result()

exports.ThermostatData = class ThermostatData extends DeviceData

  @setter SetThermostatDataRequest
  @getter GetThermostatDataRequest

  constructor: (deviceId, locationId) ->
    super deviceId, locationId
    {DeviceAction, DeviceData} = require "./device_action"
