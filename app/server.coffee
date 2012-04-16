expressjs = require "express"
assets = require "connect-assets"
env = require "../config/env"
oauth =
  config: env.oauth
  middleware: require "./middleware/oauth"
  events: require("./controllers/oauth").events

app = module.exports = expressjs.createServer()

app.configure ->
  cwd = process.cwd()
  app.set "views", "#{cwd}/app/views"
  app.set "view engine", "jade"
  app.use expressjs.bodyParser()
  app.use expressjs.methodOverride()
  app.use expressjs.cookieParser()
  app.use expressjs.session secret: env.app.secret
  app.use oauth.middleware app, oauth.events, oauth.config
  app.use app.router
  app.use assets()
  app.use expressjs.static "#{cwd}/public"

app.configure "development", ->
  app.use expressjs.errorHandler dumpExceptions: true, showStack: true

app.configure "production", ->
  app.use expressjs.errorHandler()

app.dynamicHelpers require("./helpers/application")

require("../config/routes")(app)

app.listen (process.argv?.length and parseInt process.argv[2]) or 3001
console.log "Listening on port #{app.address().port} in #{app.settings.env} mode"
