{DeviceActionCommand, DeviceActionResult, DeviceAction, DeviceProxy} = require "./device_action"

exports.SetVoltDataCommand = class SetVoltDataCommand extends DeviceActionCommand
  
  @schema
    "setVoltDataRequest":
      "@xmlns": "string"
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "data":
        "mode": "string"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    @checkOption "mode", options
    options.body =
      "setVoltDataRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
        "data":
          "mode": options.mode
    super options

exports.SetVoltDataResult = class SetVoltDataResult extends DeviceActionResult

  @schema
    "setVoltDataRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "result":
        "mode": "string"
        "@networkId": "string"
  
  mode: ->
    @result().mode if @result()

exports.GetVoltDataCommand = class GetVoltDataCommand extends DeviceActionCommand

  @schema
    "getVoltDataRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "getVoltDataRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
    super options

exports.GetVoltDataResult = class GetVoltDataResult extends DeviceActionResult
  
  @schema
    "getVoltDataRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "result":
        "mode": "string"
        "loadControlEvent":
          "loadControlEventActive": "boolean"
          "loadControlEventMandatory": "boolean"
          "loadControlEventDutyCycling": "boolean"
          "loadControlEventOptedOut": "boolean"
          "loadControlEventReturnMode": "string"
          "loadControlEventId": "string"
  
  mode: ->
    @result().mode if @result()
  
  loadControlEvent: ->
    @result().loadControlEvent if @result()

exports.SetVoltDataAction = class SetVoltDataAction extends DeviceAction

  @command SetVoltDataCommand
  @result SetVoltDataResult

exports.GetVoltDataAction = class GetVoltDataAction extends DeviceAction

  @command GetVoltDataCommand
  @result GetVoltDataResult

exports.SmartPlugProxy = class SmartPlugProxy extends DeviceProxy

  @setter SetVoltDataAction
  @getter GetVoltDataAction
