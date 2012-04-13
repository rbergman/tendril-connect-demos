{Resource} = require "./resource"
{EventEmitter} = require "./events"

class ActionResource extends Resource

  root: ->
    root = Object.keys(@constructor.schema())[0]
    @data[root] if @data

  requestId: ->
    @root()["@requestId"] if @root()

exports.ActionCommand = class ActionCommand extends ActionResource
  
  @can "create"

exports.ActionResult = class ActionResult extends ActionResource
  
  @can "load"

  requestState: ->
    @root().requestState if @root()

  completionStatus: ->
    @root().completionStatus if @root()

  failureMessage: ->
    @root().failureMessage if @root()

  result: ->
    @root().result if @root()

class Meta

  metas = {}
  
  metaFor = (T) ->
    name = T.name
    metas[name] = {} if not metas[name]
    metas[name]
  
  @metaprop: (def) ->
    k = Math.random().toString()
    (v) -> if v? then (metaFor @)[k] = v else (metaFor @)[k] or def

exports.Action = class Action extends Meta

  @command: @metaprop()

  @result: @metaprop()

  @schedule: @metaprop (250 for i in [1..16]).concat(500 for i in [1..16]).concat(1000 for i in [1..18])

  constructor: (@config={}) ->

  invoke: (options) ->
    start = Date.now()
    events = new EventEmitter
    events.names = "ready"
    schedule = @constructor.schedule()
    command = @constructor.command()
    result = @constructor.result()
    created = (cmodel) =>
      poll = (attempt=0) =>
        loaded = (lmodel) =>
          if lmodel.requestState() is "Completed"
            events.emit "ready", lmodel, Date.now() - start
          else
            if attempt < schedule.length
              doAttempt = -> poll attempt + 1
              setTimeout doAttempt, schedule[attempt]
            else
              events.emit "error", new Error "Maximum number of retries exceeded while polling for action result"
        label = "Poll for device action result (#{attempt + 1})"
        result.load(requestId: cmodel.requestId(), oauth: options.oauth, trace: label)
          .on("loaded", loaded)
          .forward(events, "error send receive trace")
      poll()
    opts = {}
    opts[k] = v for own k, v of src for src in [@config, options]
    command.create(opts)
      .on("created", created)
      .forward(events)
    events

exports.ActionProxy = class ActionProxy extends Meta
  
  @getter: @metaprop()
  
  @setter: @metaprop()
  
  constructor: (@config={}) ->
    @_waiting = false
  
  get: (options) ->
    @_send @constructor.getter(), options
  
  set: (options) ->
    @_send @constructor.setter(), options
  
  _send: (T, options) ->
    if @_waiting
      events = new EventEmitter
      process.nextTick -> events.emit "error", "ActionProxy methods are not re-entrant"
      events
    else
      @_waiting = true
      (new T @config).invoke(options)
        .on("ready", -> @_waiting = false)
        .on("error", -> @_waiting = false)
