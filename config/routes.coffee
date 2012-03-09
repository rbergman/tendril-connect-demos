controllers = require "../app/controllers"

module.exports = (app) ->

  app.get "/", controllers.home

  app.get "/#{name}/:subpage?", controllers[name] for name in Object.keys controllers
