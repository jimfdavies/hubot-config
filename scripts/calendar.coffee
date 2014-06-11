# Description:
#   Print out a calendar
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot calendar me
#
# Author:
#   Jim Davies

child_process = require('child_process')
module.exports = (robot) ->
  robot.respond /calendar( me)?/i, (msg) ->
    child_process.exec 'cal', (error, stdout, stderr) ->
      msg.send(stdout)