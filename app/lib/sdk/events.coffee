events = require "events"

unique = (a) ->
  u = {}
  u[a[i]] = a[i] for i in [0...a.length]
  v for own k, v of u

exports.EventEmitter = class EventEmitter extends events.EventEmitter
  
  constructor: (@names) ->
  
  forward: (to, names=@names) ->
    if names
      names = names.split " " if typeof names is "string"
      if to.names
        toNames = to.names.split " "
        toNames = unique toNames.concat(names)
        to.names = toNames.join " "
      for name in names when name
        do (name) => @on name, ->
          to.emit ((args = [name]).concat.apply(args, arguments))...
    @
