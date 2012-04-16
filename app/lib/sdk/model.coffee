# @todo this is old and needs to be removed; am just keeping it
#       around for now until I can decouple it from the url class

{EventEmitter} = require "events"
{XML} = require "./xml"

exports.Model = class Model
  
  marshaler = (format) ->
    if format?.toLowerCase() is "xml" then XML else JSON

  property = (k, events) ->
    event = "change:#{k}"
    fn = (v) =>
      orig = if @_data[k]? then @_data[k] else null
      if v is undefined then return orig
      if v is null then delete @_data[k]
      else @_data[k] = v
      events.emit event, k, v, orig
      @
    fn.onChange = (listener) =>
      events.on event, => listener.apply @, arguments
    fn.noChange = (listener) =>
      events.removeListener event, listener
    @[k] = fn

  @properties: (defaults={}) ->
    @::_data = {}
    events = new EventEmitter
    if typeof defaults is "string"
      hash = {}
      hash[k] = null for k in defaults.split " "
      defaults = hash
    property.call(@::, k, events)(v) for own k, v of defaults

  @fromString: (str, format) ->
    @fromJSON marshaler(format).parse str

  @fromJSON: (json) ->
    obj = new @
    obj[k] v for own k, v of json if obj[k]?
    obj
  
  toString: (format, space) ->
    marshaler(format).stringify @toJSON(), null, space
  
  toJSON: -> @_data
