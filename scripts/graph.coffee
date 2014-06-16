# Description:
#   Allows Hubot to search for and show any hostedgraphite.com graphs from given target.
#
# Dependencies:
#   None
#
# Configuration
#   HOSTEDGRAPHITE_ACCESS_URL (e.g. https://www.hostedgraphite.com/xxx/yyy/graphite)
#
# Commands:
#   hubot graph me <target> - Display a graph of your Hosted Graphite metric
# 
# Notes:
#   Simple example:
#   hubot graph me internal.foo.bar.i-abababab.cpu.usage.user
# 
#   Complex example:
#   hubot graph me sumSeries(exclude(aggregates.internal.foo.bar.baz.all.cpu.usage.*,"idle"))
#
# Authors:
#   jimfdavies
#

module.exports = (robot) ->
  robot.respond /graph me ([^\s]+)/i, (msg) ->
    target = msg.match[1]
    fromhrs = msg.match[2] || 3
    width = 600
    format = "png"
    linemode = "connected"

    base = "/render/?"
    opt_target = "&target=#{target}"
    opt_from = "&from=-#{fromhrs}hrs"
    opt_width = "&width=#{width}"
    opt_linemode = "&lineMode=#{linemode}"
    opt_format = "&.#{format}"

    url = process.env.HOSTEDGRAPHITE_ACCESS_URL + base + encodeURI(opt_target) + opt_from + opt_width + opt_linemode + opt_format
    msg.http(url)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send url
          else
            msg.send "Sorry. I can't seem to get that graph. [Error #{res.statusCode}: #{url}]"
