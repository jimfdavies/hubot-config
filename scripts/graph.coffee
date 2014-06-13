# Description:
#   Allows Hubot to search for and show any hostedgraphite.com graphs from given target
#
# Dependencies:
#   None
#
# Configuration
#   HOSTEDGRAPHITE_ACCESS_URL (e.g. https://www.hostedgraphite.com/xxx/yyy/graphite)
#
# Commands:
#   hubot graph me <target>
#
# Authors:
#   jimfdavies
#

module.exports = (robot) ->
  robot.respond /graph me ([^\s]+)/i, (msg) ->
    metric = msg.match[1]
    fromhrs = msg.match[2] || 3
    
    uri = "/render/?_salt=1402587759.714"
    timestamp = '#' + new Date().getTime()
    target = "&target=" + metric
    from = "&from=-" + fromhrs + "hrs"
    format = "&format=png"
    suffix = "&.png"
    url = process.env.HOSTEDGRAPHITE_ACCESS_URL + uri + target + from + suffix
    msg.http(url)
      .get() (err, res, body) ->
        if res.statusCode isnt 200
          msg.send "Cannot access (#{res.statusCode}): #{url}"
          return
      msg.send url
