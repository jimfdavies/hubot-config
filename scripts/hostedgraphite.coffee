# Description:
#   Allows Hubot to search for and show hostedgraphite.com saved graphs
#
# Dependencies:
#   None
#
# Configuration
#   HOSTEDGRAPHITE_ACCESS_URL (e.g. https://www.hostedgraphite.com/xxx/yyy/graphite)
#
# Commands:
#   graphite list - list all available graphs
#   graphite search <string> - search for graph by name
#   graphite show <graph.name> - output graph
#
# Notes:
#   1) Sign up for hostedgraphite.com and create a 'read-only access URL' via the
#      accounts page.
#   2) HipChat has a 500 character limit on image URLs, meaning that crazy long
#      graphite render URLs won't load image previews.
#
# Authors:
#   obfuscurity
#   spajus
#   ampledata
#


module.exports = (robot) ->
  robot.hear /graphite list/i, (msg) ->
    treeversal msg, (data) ->
      output = ""
      output += "#{human_id(metric)}\n" for metric in data
      msg.send output
  robot.hear /graphite search (\w+)/i, (msg) ->
    treeversal msg, (data) ->
      output = ""
      output += "#{human_id(metric)}\n" for metric in data
      msg.send output
  robot.hear /graphite show (\S+)/i, (msg) ->
    treeversal msg, (data) ->
      construct_url msg, data[0].graphUrl, (url) ->
        msg.send url


construct_url = (msg, graphUrl, cb) ->
  graphRegex = /(\bhttps?:\/\/)(\S+)(\/render\/\S+)$/
  serverRegex = /(\bhttps?:\/\/)(\S+)$/
  uri = graphUrl.match(graphRegex)[3]
  timestamp = '#' + new Date().getTime()
  suffix = '&.png'
  newUrl = process.env.HOSTEDGRAPHITE_ACCESS_URL + uri + timestamp + suffix
  cb(newUrl)


treeversal = (msg, cb, node="") ->
  data = []
  if node == ""
    prefix = "*"
  else
    if node.slice(-1) == '.'
      prefix = node + "*"
    else
      prefix = node + ".*"
  uri = "/browser/usergraph/?query=#{prefix}&format=treejson&contexts=1&path=#{node}&node=#{node}"
  headers = { Accept: "application/json", 'Content-type': 'application/json' }
  msg
    .http(process.env.HOSTEDGRAPHITE_ACCESS_URL + uri)
    .headers(headers)
    .get() (err, res, body) ->
      unless res.statusCode is 200
        console.log(res)
      nodes = JSON.parse body
      i = 0
      while (i < nodes.length)
        if nodes[i].leaf == 0
          treeversal(msg, cb, nodes[i].id)
        else
          regex = new RegExp(msg.match[1], "gi")
          unless human_id(nodes[i]).search(regex) == -1
            unless nodes[i].id == "no-click"
              data[data.length] = nodes[i]
        i++
      cb(data) if data.length > 0


human_id = (node) ->
  node.id.replace /\.[a-z0-9]+$/, ".#{node.text}"
  