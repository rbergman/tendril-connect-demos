module.exports = (config) ->

  (req, res, oauth, locals) ->
  
    locals[k] = v for own k, v of config
  
    env =
      request: req
      oauth: oauth
      locals: locals

    events =
      trace: (req, res, label, elapsed) ->
        console.log "--- #{label} [#{elapsed}ms] ---\n#{req.method} #{req.url} -> #{res.statusCode} #{res.status}"
        # console.log "--- #{label} ---\n[#{elapsed}ms]\n\n#{req.toString()}\n\n#{res.toString()}\n"
        locals.trace.push request: req, response: res, label: label, elapsed: elapsed
      done: ->
        res.render()
      fail: (err) ->
        locals.error = err
        locals.notFound = true if err.response?.statusCode is 404
        res.render()

    config.action(env, events)
