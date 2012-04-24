module.exports = (options) ->
  
  helpers = {}
  helpersFor = (file) ->
    return helpers[file] if helpers[file]
    paths = require "path"
    path = paths.normalize "#{__dirname}/../helpers/#{file}.coffee"
    helpers[file] = if paths.existsSync path then require path else {}
  
  (req, res, oauth) ->
  
    subpage = req.params.subpage or options.subpages[0].name
    if subpage not in (sp.name for sp in options.subpages)
      res.send 404
    else
      file = "#{options.name}_#{subpage}"
      subcontroller = require("./#{file}")
      locals =
        trace: []
        subpages: options.subpages
        subpage: subpage
        section:
          name: options.name
          title: options.title
        ns: req.query.ns
      locals[k] = v for own k, v of helpersFor(file)
      if req.xhr
        _res = render: -> res.partial "subpage_layout", locals
        subcontroller req, _res, oauth, locals
      else
        res.render options.name, locals
