{Resource} = require "./resource"
{EventEmitter} = require "./events"

exports.DeviceAction = class DeviceAction extends Resource

  @path "/device-action/{request-id}?"
  
  @can "create load"
  
  @rootFor: (self) ->
    self.name.replace /^\w/, (c) -> c.toLowerCase()
  
  root: ->
    @data[@constructor.rootFor @constructor] if @data

  requestId: ->
    @root()["@requestId"] if @root()

  requestState: ->
    @root().requestState if @root()

  completionStatus: ->
    @root().completionStatus if @root()
  
  failureMessage: ->
    @root().failureMessage if @root()
  
  result: ->
    @root().result if @root()

exports.DeviceData = class DeviceData

  metas = {}
  
  metaFor = (T) ->
    name = T.name
    metas[name] = {} if not metas[name]
    metas[name]
  
  @metaprop: (def) ->
    k = Math.random().toString()
    (v) -> if v? then (metaFor @)[k] = v else (metaFor @)[k] or def

  @setter: @metaprop()

  @getter: @metaprop()

  @schedule: @metaprop (250 for i in [1..16]).concat(500 for i in [1..16]).concat(1000 for i in [1..18])

  constructor: (@deviceId, @locationId) ->
    @_waiting = false

  set: (options) ->
    @_send(@constructor.setter(), options)

  get: (options) ->
    @_send(@constructor.getter(), options)

  _send: (T, options) ->
    events = new EventEmitter
    events.names = "resolved"
    if @_waiting
      events.emit "error", new Error "A pending device action is already in flight (dev:#{@deviceId}@loc:#{@locationId})"
    else
      @_waiting = true
      schedule = @constructor.schedule()
      start = Date.now()
      created = (cmodel) =>
        poll = (attempt=0) =>
          loaded = (lmodel) =>
            if lmodel.requestState() is "Completed"
              @_waiting = false
              events.emit "ready", lmodel, Date.now() - start
            else
              if attempt < schedule.length
                doAttempt = -> poll attempt + 1
                setTimeout doAttempt, schedule[attempt]
              else
                events.emit "error", new Error "Maximum number of retries exceeded while polling for device action result"
          label = "Poll for device action result (#{attempt + 1})"
          @constructor.getter().load(requestId: cmodel.requestId(), oauth: options.oauth, trace: label)
            .on("loaded", loaded)
            .forward(events, "error send receive trace")
        poll()
      
      opts = deviceId: @deviceId, locationId: @locationId
      opts[k] = v for own k, v of options
      T.create(opts)
        .on("created", created)
        .forward(events)
    events.on "error", => @_waiting = false
    events
