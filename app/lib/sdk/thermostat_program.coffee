{DeviceActionCommand, DeviceActionResult, DeviceAction, DeviceProxy} = require "./device_action"

exports.SetThermostatProgramCommand = class SetThermostatProgramCommand extends DeviceActionCommand

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

exports.GetThermostatProgramCommand = class GetThermostatProgramCommand extends DeviceActionCommand

  @schema
    "getThermostatProgramRequest":
      "@deviceId": "string"
      "@locationId": "string"
      "@requestId": "string"

  @create: (options={}) ->
    @checkOption "deviceId", options
    @checkOption "locationId", options
    options.body =
      "getThermostatProgramRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems"
        "@deviceId": options.deviceId
        "@locationId": options.locationId
    super options

exports.GetThermostatProgramResult = class GetThermostatProgramResult extends DeviceActionResult

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

  program: ->
    @result().thermostatProgram if @result()

exports.SetThermostatProgramAction = class SetThermostatProgramAction extends DeviceAction

  @command SetThermostatProgramCommand
  @result GetThermostatProgramResult

exports.GetThermostatProgramAction = class GetThermostatProgramAction extends DeviceAction

  @command GetThermostatProgramCommand
  @result GetThermostatProgramResult

exports.ThermostatProgramProxy = class ThermostatProgramProxy extends DeviceProxy

  @setter SetThermostatProgramAction
  @getter GetThermostatProgramAction
