{DeviceAction, DeviceData} = require "./device_action"

exports.SetVoltDataRequest = class SetVoltDataRequest extends DeviceAction
  
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

exports.GetVoltDataRequest = class GetVoltDataRequest extends DeviceAction
  
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

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "getVoltDataRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
    super options

  constructor: (data, self) ->
    super data, self
  
  mode: ->
    @result().mode if @result()
  
  loadControlEvent: ->
    @result().loadControlEvent if @result()

exports.SmartPlugData = class SmartPlugData extends DeviceData

  @setter SetVoltDataRequest
  @getter GetVoltDataRequest

  constructor: (deviceId, locationId) ->
    super deviceId, locationId
