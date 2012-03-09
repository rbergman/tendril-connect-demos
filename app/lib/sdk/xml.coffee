{SaxParser} = require "libxmljs"

exports.XML =
  
  parse: (xml, types={}) ->

    dom = {}
    stack = []
    path = []
    buffer = ""

    parser = new SaxParser

      startDocument: -> stack.unshift dom
      endDocument: -> stack.shift()
      characters: (chars) -> buffer += chars
      cdata: (cdata) -> buffer += cdata
      warning: (msg) -> console.warn msg
      error: (err) -> throw new Error err
      comment: (comment) -> # skip

      startElementNS: (name, attrs, prefix, uri, namespaces) ->
        qname = "#{if prefix then prefix + ':' else ''}#{name}"
        path.push qname
        el = {}
        el["@#{if attr[1] then attr[1] + ':' else ''}#{attr[0]}"] = attr[3] for attr in attrs
        el["@xmlns#{if ns[0] then ':' + ns[0] else ''}"] = ns[1] for ns in namespaces
        parent = stack[0]
        other = parent[qname]
        if other
          if other not instanceof Array
            other = parent[qname] = [other]
          other.push el
        else
          parent[qname] = if types["/#{path.join "/"}"] is "array" then [el] else el
        stack.unshift el

      endElementNS: (name, prefix, uri) ->
        qname = "#{if prefix then prefix + ':' else ''}#{name}"
        buffer = buffer.replace(/^\s*|\s*$/g, "")
        el = stack[0]
        isLeaf = Object.keys(el).length is 0
        if buffer
          value = (last) ->
            switch types["/#{path.join "/"}#{if last then '/' + last else ''}"]
              when "boolean" then buffer.toLowerCase() is "true"
              when "integer" then parseInt buffer, 10
              when "float" then parseFloat buffer
              when "datetime" then new Date buffer
              else buffer
          if isLeaf
            parent = stack[1]
            if parent[qname] instanceof Array
              parent[qname][parent[qname].length - 1] = value()
            else
              parent[qname] = value()
          else
            el.$ = value "$"
          buffer = ""
        else if isLeaf
          delete stack[1][qname]
        stack.shift()
        path.pop()

    parser.parseString xml
    dom

  stringify: (dom, root, space) ->

    xml = ""
    depth = 0
    stack = []

    item = (name, el, escape) ->
      type = typeof el
      if el instanceof Array
        array name, el
      else if type is "string" or type is "number" or type is "boolean"
        xml += simple name, el, escape
      else if el?
        if type is "object"
          element name, el
        else
          console.warn "Unsupported el value when converting to XML: #{name} -> #{el}"

    array = (name, elements) ->
      item name, el for el in elements
    
    isAttr = (name) -> name.charAt(0) is "@"

    element = (name, el) ->
      keys = Object.keys(el)
      if name?
        push name
        xml += indent() + "<#{name}"
        xml += " #{k.slice 1}=\"#{escape el[k].toString()}\"" for k in keys when el[k]? and isAttr(k)
        xml += ">"
      if el.$?
        xml += el.$
      else
        xml += newline()
        depth += 1 if name?
        item k, el[k] for k in keys when not isAttr(k) and k isnt "$"
        depth -= 1 if name?
        xml += indent()
      if name?
        xml += "</#{name}>"
        xml += newline()
        pop()

    simple = (name, value, esc) ->
      "#{indent()}<#{name}>#{if esc then escape value else value}</#{name}>#{newline()}"

    indent = (d=depth) ->
      if space > 0 and d > 0 then (" " for i in [0..(d * space) - 1]).join("") else ""

    newline = -> if space > 0 then "\n" else ""

    escape = (str) ->
      if typeof str is "string"
        str.replace /[<>&"']/g, (char) ->
          switch char
            when "<" then "&lt;"
            when ">" then "&gt;"
            when "&" then "&amp;"
            when '"' then "&quot;"
            when "'" then "&apos;"
      else
        str

    push = (name) -> stack.push name

    pop = -> stack.pop()

    path = -> "/" + stack.join("/")

    xml = '<?xml version="1.0" encoding="UTF-8"?>'
    xml += newline() if root?
    item root, dom
    xml

# el =
#   "document":
#     "@foo": "bar"
#     "@xmlns": "urn:main-ns"
#     "empty": null
#     "value": [1, 2, 3]
#     "ns:boo":
#       "@xmlns:ns": "urn:ns"
#       "@ns:baz": 1
#       "@biz": null
#       "$": "toast"
#     "item": [
#       {"one": 1}
#       {"two": 2}
#       {"three": 3}
#     ]
# 
# p = exports.XML.parse
# s = exports.XML.stringify
# console.log JSON.stringify(el, null, 2)
# console.log JSON.stringify(p(s(el, null, 2)), null, 2)
# console.log s(el, null, 2)
# console.log s(p(s(el, null, 2)), null, 2)
