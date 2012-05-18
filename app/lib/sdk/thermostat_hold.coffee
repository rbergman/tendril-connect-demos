{DeviceActionCommand, DeviceActionResult, DeviceAction, DeviceProxy} = require "./device_action"

exports.GetThermostatHoldCommand = class GetThermostatHoldCommand extends DeviceActionCommand

  @schema
    "getThermostatProgramHoldStatusRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "getThermostatProgramHoldStatusRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
    super options

exports.GetThermostatHoldResult = class GetThermostatHoldResult extends DeviceActionResult

  @schema
    "getThermostatProgramHoldStatusRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "result":
        "holdStatus": "string"

  holdStatus: ->
    @result().holdStatus if @result()

exports.GetThermostatHoldAction = class GetThermostatHoldAction extends DeviceAction

  @command GetThermostatHoldCommand
  @result GetThermostatHoldResult
