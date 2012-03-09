# expressjs

expressjs = require "express"
assets = require "connect-assets"
oauth =
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
  app.use expressjs.session secret: "honey badger!"
  app.use oauth.middleware(app, oauth.events)
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

# nowjs
#
#nowjs = require "now"
#
# everyone = nowjs.initialize app
# 
# nowjs.on "connect", ->
#   console.log "Joined: #{@now.name}"
# 
# nowjs.on "disconnect", ->
#   console.log "Left: #{@now.name}"
# 
# everyone.now.distributeMessage = (message) ->
#   everyone.now.receiveMessage @now.name, message
