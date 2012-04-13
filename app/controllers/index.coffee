files = ['home', 'help', 'user', 'metering', 'pricing', 'devices', 'building', 'greenbutton']
for file in files
  do (file) ->
    controller = require "./#{file}"
    for own name, action of controller
      do (name, action) ->
        exports[name] = (req, res) ->
          if controller.protected
            oauth = req.session.oauth
            if oauth?.authenticated
              action req, res, oauth
            else
              req.flash "error", "You must log in to view the demos"
              res.redirect "/"
          else
            action req, res

