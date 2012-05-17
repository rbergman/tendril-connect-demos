http = require "http"
https = require "https"
{EventEmitter} = require "./events"
{Url} = require "./url"
{XML} = require "./xml"

exports.rest =
  get: (url, accessToken, label) -> request "GET", url, accessToken, undefined, label
  post: (url, accessToken, body, label) -> request "POST", url, accessToken, body, label
  put: (url, accessToken, body, label) -> request "PUT", url, accessToken, body, label
  del: (url, accessToken, label) -> request "DELETE", url, accessToken, undefined, label

request = (method, url, accessToken, body, label) ->
  events = new EventEmitter "error send receive trace success redirect complete"
  error = (err) -> events.emit "error", err
  url = new Url url if typeof url is "string"
  transport = if url.protocol() is "https" then https else http
  headers =
    "Accept": "application/xml"
    "Access_Token": accessToken
  headers["Content-Type"] = "application/xml" if body
  options = url.toOptions method: method, headers: headers
  xreq = new RequestTrace method, url.toString(), headers, body
  start = Date.now()
  req = transport.request options, (res) ->
    data = ""
    res.on "data", (chunk) -> data += chunk
    res.on "end", ->
      code = res.statusCode
      xres = new ResponseTrace code, res.headers, data
      events.emit "receive", xres, label
      events.emit "trace", xreq, xres, label, Date.now() - start
      if 200 <= code < 300
        events.emit "success", xres
      else if 300 <= code < 400
        events.emit "redirect", xres
      else
        error new HttpError xreq, xres
      events.emit "complete", xreq, xres
  req.on "error", error
  req.write body if body
  req.end()
  process.nextTick -> events.emit "send", xreq, label
  events

class Trace
  constructor: (headers, @body) ->
    @headers = {}
    for own k, v of headers
      k = k.replace /(^[a-z])|(-[a-z])/g, (c) -> c.toUpperCase()
      @headers[k] = v
  formatBody: (space=2) ->
    switch @headers["Content-Type"]
      when "application/xml", "text/xml"
        XML.stringify(XML.parse(@body), null, space)
      when "application/json", "text/json"
        JSON.stringify(JSON.parse(@body), null, space)
      else
        @body
  toString: (pretty) ->
    redactions = ["Set-Cookie", "Access_Token"]
    str = ""
    str += "\n#{k}: #{if k in redactions then '[redacted]' else v}" for own k, v of @headers
    str += "\n\n#{if pretty then @formatBody() else @body}" if @body
    str

class RequestTrace extends Trace
  constructor: (@method, @url, headers, body) ->
    super headers, body
  toString: (pretty) ->
    str = "HTTP/1.1 #{@method} #{@url.toString()}"
    str += super(pretty)
    str

class ResponseTrace extends Trace
  constructor: (@statusCode, headers, body) ->
    super headers, body
    @status = http.STATUS_CODES[@statusCode.toString()]
  toString: (pretty) ->
    str = "HTTP/1.1 #{@statusCode} #{@status}"
    str += super(pretty)
    str

class HttpError extends Error
  constructor: (request, response) ->
    super
    Error.captureStackTrace @, @constructor
    @name = @constructor.name
    @request = request
    @response = response
    @message = "#{@name}: #{@response.statusCode} #{@response.status} (#{@request.method} #{@request.url.toString()})"
  toString: (pretty)->
    "#{@request.toString(pretty)}\n\n#{@response.toString(pretty)}"
