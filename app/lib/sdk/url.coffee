{Model} = require "./model"

exports.Url = class Url extends Model

  @properties "protocol host port path matrix query"

  enc = encodeURIComponent
  dec = decodeURIComponent

  parse = (str) ->
    options = require("url").parse str, true
    options.path = options.pathname
    parts = options.path.split ";"
    if parts.length > 1
      options.path = parts[0]
      matrix = options.matrix = {}
      for part, i in parts when i > 0
        [k, v] = part.split "="
        matrix[dec(k)] = dec(v) 
    options
  
  replace = (str, values) ->
    if values then str.replace /\{([\w\-]+)\}/g, ($0, $1) -> values[$1] or $0 else str
  
  constructor: (options={}, values) ->
    options = parse replace(options, values) if typeof options is "string"
    @[k] v for own k, v of options when @[k]
    protocol = @protocol()
    @protocol protocol.slice(0, protocol.length - 1) if protocol
    @base options.base if options.base

  base: (v) ->
    if v
      base = parse v
      @[k] base[k] for k in ['protocol', 'host', 'port'] if base[k]?
    else if @host()
      "#{@protocol() or 'http'}://#{@host()}#{if @port() then ':' + @port() else ''}"
    else
      ""
  
  toString: (pathOnly, values) ->
    values = pathOnly if typeof pathOnly is "object"
    pathstr = (path) -> if path then replace path, values else ""
    paramstr = (params, sep, lead=sep) ->
      if params and Object.keys(params).length
        lead + ("#{enc(k)}=#{enc(v)}" for own k, v of params).sort().join(sep)
      else ""
    "#{if pathOnly isnt true then @base() else ''}#{pathstr @path()}#{paramstr @matrix(), ';'}#{paramstr @query(), '&', '?'}"
  
  toOptions: (options={}) ->
    options.host = @host()
    options.port = @port()
    options.path = @toString true
    options
