{Resource} = require "./resource"
{EventEmitter} = require "./events"
{ActionCommand, ActionResult, Action, ActionProxy} = require "./action_request"

exports.DeviceActionCommand = class DeviceActionCommand extends ActionCommand

  @createPath "/device-action"

exports.DeviceActionResult = class DeviceActionResult extends ActionResult

  @path "/device-action/{request-id}"

exports.DeviceAction = class DeviceAction extends Action

exports.DeviceProxy = class DeviceProxy extends ActionProxy
  
  constructor: (deviceId, locationId) ->
    super deviceId: deviceId, locationId: locationId
