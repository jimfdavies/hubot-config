# Description:
#   Prints out this month's ASCII calendar.
#
# Commands:
#   hubot calendar [me] - Print out this month's calendar

child_process = require('child_process')
module.exports = (robot) ->
  robot.respond /calendar( me)?/i, (msg) ->
    child_process.exec 'cal', (error, stdout, stderr) ->
      msg.send(stdout)