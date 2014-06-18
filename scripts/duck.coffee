# Description:
# Get a result from the duckduckgo.com api
#
# Dependencies:
# None
#
# Configuration:
# None
#
# Commands:
# hubot wtf <search term> - search for <search term> via DuckDuckGo Instant Search
# hubot duck me <search term> - search for <search term> via DuckDuckGo Instant Search
#
# Author:
# jimfdavies
# juan.ceron@pure360.com (forked from https://gist.github.com/juanmirod/8030118)
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
              response += "#{r.Text} #{r.FirstURL}\n"
        when "C" 
          response = "That's a pretty broad topic. Try this website #{results.AbstractURL}"
        when "A"
          response = "#{results.Image}\n"
          response += "#{results.AbstractText}\n"
          response += "More: #{results.AbstractURL}\n"
          response += "[taken from #{results.AbstractSource} via DuckDuckGo API]"
        else
          response = "Sorry. I have no idea what you mean. Try Uncle Google (http://www.google.com/#q=#{query})"

      msg.send response      

      
module.exports = (robot) ->
  robot.respond /wtf (.*)/i, (msg) ->
    getDefinition msg, msg.match[1]

  robot.respond /duck me (.*)/i, (msg) ->
    getDefinition msg, msg.match[1]