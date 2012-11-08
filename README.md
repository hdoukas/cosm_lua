cosm_lua
========
Basic Lua functions for reading sensor feeds from Cosm (www.cosm.com)

read_current(apikey,feed, datastream)
Returns the current value of a given datastream id that belongs to a given feed id.
You have to provide a valid Cosm API Key with reading permissions

read_24h(apikey, feed, datastream)
Returns a JSON object containing the average, maximum and minimum datastream values for the past 24 hours, e.g. [18.275, 81.3, 4.2].
You have to provide a valid Cosm API Key with reading permissions

Built for using with Webscript (www.webscript.io)
