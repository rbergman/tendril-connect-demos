{EventEmitter} = require "./events"
{Url} = require "./url"
{rest} = require "./rest"
{XML} = require "./xml"
{inspect} = require "util"

exports.Resource = class Resource

  request = (T, method, pathFnName, options) ->
    events = new EventEmitter "loaded created saved destroyed"
    error = (msg) -> process.nextTick -> events.emit "error", new Error msg
    host = options.oauth?.host or "https://dev.tendrilinc.com" if not options.host
    accessToken = options.oauth?.access_token or options.access_token if not options.accessToken
    needsBody = method in ["post", "put"]
    if not accessToken
      error "No access token value specified"
    else if needsBody and not options.body
      error "No body provided to #{method} operation"
    else
      url = new Url(host)
        .path(T[pathFnName](options))
        .matrix(T.params("matrix", options))
        .query(T.params("query", options))
      body = XML.stringify options.body if typeof options.body is "object"
      args = [url, accessToken].concat(if needsBody then [body, options.trace] else [options.trace])
      req = rest[method].apply(rest, args).forward(events)
    [events, req, url]
  
  parse = (res, types) ->
  
  emitNewResource = (events, event, T, url) ->
    (res) ->
      if res.body and res.headers["Content-Type"]?.indexOf("application/xml") is 0
        data = XML.parse res.body, metaFor(T).types
        events.emit event, new T(data, res.headers.location or url.toString())
      else
        events.emit "error", new Error("Expected XML body in response:\n#{res.toString()}")

  traits =

    load:
      canLoad: -> true
      load: (options={}) ->
        [events, req, url] = request @, "get", "path", options
        req.on("success", emitNewResource(events, "loaded", @, url)) if req
        events

    create:
      canCreate: -> true
      create: (options={}) ->
        [events, req, url] = request @, "post", "createPath", options
        req.on("success", emitNewResource(events, "created", @, url)) if req
        events

    save:
      canUpdate: -> true
      update: (options={}) ->
        [events, req, url] = request @construT, "put", "path", options
        req.on("success", -> events.emit "saved") if req
        events

    destroy:
      canDestroy: -> true
      destroy: (options={}) ->
        [events, req, url] = request @construT, "del", "path", options
        req.on("success", -> events.emit "destroyed") if req
        events

  metas = {}
  
  metaFor = (T) ->
    name = T.name
    metas[name] = {} if not metas[name]
    metas[name]

  doPath = (T, type, value, spec) ->
    meta = metaFor T
    if typeof value is "string"
      meta[type] = "/connect#{value}"
      addParams T, "#{type}_template", spec if spec
    else
      path = meta[type]
      if not path
        sup = T.__super__.constructor
        path = doPath sup, type, value, spec if sup
      if path and typeof value is "object"
        path.replace /\{([\w\-]+)\}/g, ($0, $1) ->
          alt = $1.replace /\-([a-z])/g, ($0, c) -> c.toUpperCase()
          if value[$1]? then value[$1]
          else if value[alt]? then value[alt]
          else if meta["#{type}_template"][$1]? then meta["#{type}_template"][$1]
          else $0
  
  express = (T, members, static) ->
    (if static then T else T::)[k] = v for own k, v of members if members?
  
  addParams = (T, type, spec="") ->
    meta = metaFor T
    meta[type] = {} if not meta[type]
    if typeof spec is "string"
      meta[type][name] = null for name in spec.split " " when name
    else
      meta[type] = spec

  value: (path, ctx=@data) ->
    el = undefined
    parts = path.split "/"
    last = parts.length - 1
    for part, i in parts when part and ctx?
      if i is last then el = ctx[part]
      else ctx = ctx[part]
    el

  @createPath: (value, spec) ->
    doPath @, "createPath", value, spec

  @path: (value, spec) ->
    if typeof value is "string"
      match = /^((.*?)\/\{[\w\-]+\})\?$/.exec value
      if match
        doPath @, "path", match[1], spec
        doPath @, "createPath", match[2], spec
      else
        doPath @, "path", value, spec
    else
      doPath @, "path", value, spec
    
  @params: (type, options) ->
    meta = metaFor @
    params = {}
    if meta[type]
      for own param, def of meta[type]
        alt = param.replace /\-([a-z])/g, ($0, c) -> c.toUpperCase()
        value = options[param] or options[alt] or def
        params[param] = value if value?
    params

  @matrix: (spec) ->
    addParams @, "matrix", spec

  @query: (spec) ->
    addParams @, "query", spec
  
  @checkOption: (name, options) ->
    throw new Error "Required option #{name} not found in:\n#{inspect(options)}" if not options[name]?
  
  @schema: (root) ->
    meta = metaFor @
    meta.types = {}
    flatten = (obj, ctx="") ->
      for own k, v of obj
        path = "#{ctx}/#{k}"
        if typeof v is "object"
          if k.charAt(k.length - 1) is "*"
            path = path.slice 0, path.length - 1
            meta.types[path] = "array"
          else
            meta.types[path] = "object"
          flatten v, path
        else
          meta.types[path] = v
    flatten root
  
  @can: (capabilities) ->
    for capability in capabilities.split " " when capability
      express @, traits[capability], capability in ["load", "create"]

  @canLoad: -> false

  @canCreate: -> false

  canUpdate: -> false

  canDelete: -> false

  constructor: (@data, @self) ->
