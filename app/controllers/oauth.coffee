{User} = require "../lib/sdk/user"

exports.events =
  
  connected: (req, res) ->
    error = (err) ->
      console.error err.toString()
      req.flash "error", "Unable to fetch user information after OAuth log in"
      res.redirect "/", 303
    loaded = (user) ->
      req.session.user = user
      res.redirect "/", 303
    User.load(oauth: req.session.oauth)
      .on("error", error)
      .on("loaded", loaded)

  disconnected: (req, res) ->
    req.session.user = null
    res.redirect "/", 303

  denied: (err, req, res) ->
    req.flash "error", err
    res.redirect "/", 303
  
  error: (err, req, res) ->
    req.flash "error", err
    res.redirect "/", 303
