{DeviceActionCommand, DeviceActionResult, DeviceAction, DeviceProxy} = require "./device_action"

exports.SetThermostatDataCommand = class SetThermostatDataCommand extends DeviceActionCommand
  
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

exports.SetThermostatDataResult = class SetThermostatDataResult extends DeviceActionResult

  @schema
    "setThermostatDataRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "result":
        # @todo review - are these fields right for set results?
        "setpoint": "float"
        "mode": "string"
        "temperatureScale": "string"
        "currentTemp": "float"
        "activeLoadControlEvent": "boolean"

exports.GetThermostatDataCommand = class GetThermostatDataCommand extends DeviceActionCommand

  @schema
    "getThermostatDataRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "getThermostatDataRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
    super options

exports.GetThermostatDataResult = class GetThermostatDataResult extends DeviceActionResult
  
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

exports.SetThermostatDataAction = class SetThermostatDataAction extends DeviceAction

  @command SetThermostatDataCommand
  @result SetThermostatDataResult

exports.GetThermostatDataAction = class GetThermostatDataAction extends DeviceAction
  
  @command GetThermostatDataCommand
  @result GetThermostatDataResult

exports.ThermostatProxy = class ThermostatProxy extends DeviceProxy

  @setter SetThermostatDataAction
  @getter GetThermostatDataAction
