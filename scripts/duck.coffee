# Description:
# Get a definition from duckduckgo.com api
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# hubot define (.*) - return the definition of the word/phrase
#
# Author:
# juan.ceron@pure360.com (forked from https://gist.github.com/juanmirod/8030118)
# jimfdavies
#
getDefinition = (msg, query) ->
  msg.http("http://api.duckduckgo.com/?q=#{query}&format=json&t=hubotscript")
    .get() (err, res, body) ->
      results = JSON.parse body
      
      switch results.Type
        when "D" 
          response = "That could mean a few things...\n"
          for r in results.RelatedTopics
            if r.Result
              #response += "#{r.Icon.URL}\n"
              response += "#{r.Text}\n"

        when "C" 
          response = "That's a pretty broad topic. Try this website #{results.AbstractURL}"
        when "A"
          response = "#{results.Image}\n"
          response += "#{results.Abstract}\n"
          response += "[taken from #{results.AbstractSource} via DuckDuckGo API]"
        else
          response = "Sorry. I have no idea what you mean. Try Uncle Google (http://www.google.com/#q=#{query})"

      msg.send response      

      
module.exports = (robot) ->
  robot.respond /(define )(.*)/i, (msg) ->
    getDefinition msg, msg.match[2]

  robot.respond /wtf (.*)/i, (msg) ->
    getDefinition msg, msg.match[2]

  robot.respond /duck me (.*)/i, (msg) ->
    getDefinition msg, msg.match[1]