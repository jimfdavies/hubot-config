# Description:
#   Reacts to Sensu tags
#
# Commands:
# 

module.exports = (robot) ->
  robot.hear /(.*)#sensu/i, (msg) ->
    msg.reply "Oh oh."