{DeviceAction, DeviceData} = require "./device_action"

exports.SetThermostatProgramRequest = class SetThermostatProgramRequest extends DeviceAction

  @schema
    "setThermostatProgramRequest":
      "@xmlns": "string"
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "data":
        "thermostatProgram":
          "@programId": "string"
          "programDays*":
            "@dayOfWeek": "string"
            "programSegment*":
              "name": "string"
              "timeOfDay": "string"
              "heatingSetPoint": "float"
              "coolingSetPoint": "float"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    @checkOption "program", options
    options.body =
      "setThermostatProgramRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
        "data": options.program
    super options

exports.GetThermostatProgramRequest = class GetThermostatProgramRequest extends DeviceAction

  @schema
    "getThermostatProgramRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"
      "result":
        "thermostatProgram":
          "@programId": "string"
          "programDays*":
            "@dayOfWeek": "string"
            "programSegment*":
              "name": "string"
              "timeOfDay": "string"
              "heatingSetPoint": "float"
              "coolingSetPoint": "float"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "getThermostatProgramRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
    super options

  constructor: (data, self) ->
    super data, self

  program: ->
    @result().thermostatProgram if @result()

exports.ThermostatProgram = class ThermostatProgram extends DeviceData

  @setter SetThermostatProgramRequest
  @getter GetThermostatProgramRequest

  constructor: (deviceId, locationId) ->
    super deviceId, locationId
