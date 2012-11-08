--required for parsing XML response from Cosm
local lom = require 'lxp.lom'
local xpath = require 'webscriptio/lib/xpath.lua'

local read_current = function (apikey,feed, datastream) 
	local response = http.request {
	method='get',
	url = 'http://api.cosm.com/v2/feeds/'..feed..'/datastreams/'..datastream,
	headers =  { ["X-PachubeApiKey"] = tostring(apikey) } }
	return json.parse(response.content).current_value
end

local read_24h = function (apikey, feed, datastream) 
	local response = http.request {
	method='get',
	url = 'http://api.cosm.com/v2/feeds/'..feed..'/datastreams/'..datastream..'/?duration=24hours&interval=60',
	headers =  { ["X-PachubeApiKey"] = tostring(apikey) } }

	local values = json.parse(response.content).datapoints
	local sum = 0
	local debug =""
	local max = -math.huge
	local min = math.huge
	for i=1,# values do
        	sum=sum+values[i].value
        	max = math.max( max, values[i].value)
		min = math.min( min, values[i].value)
  	end
	return {sum/#values, max, min}		
end

-- returns something like: {"datastreams": ["cpu_0,2012-11-08T17:30:28.877620Z,24.50", "cpu_1,2012-11-08T17:30:28.877620Z,26.57"], "size": 2} 
function list_datastreams(apikey, feed)
	local response = http.request {
	method='get',
	url = 'http://api.cosm.com/v2/feeds/'..feed..'.csv',
	headers = { ["X-PachubeApiKey"] = tostring(apikey) } }
	local datastreams = split(tostring(response.content), '\n')
	local temp =""
	
	return {size=#datastreams, datastreams=datastreams}
	
end

split = function(s, pattern, maxsplit)
  local pattern = pattern or ' '
  local maxsplit = maxsplit or -1
  local s = s
  local t = {}
  local patsz = #pattern
  while maxsplit ~= 0 do
    local curpos = 1
    local found = string.find(s, pattern)
    if found ~= nil then
      table.insert(t, string.sub(s, curpos, found - 1))
      curpos = found + patsz
      s = string.sub(s, curpos)
    else
      table.insert(t, string.sub(s, curpos))
      break
    end
    maxsplit = maxsplit - 1
    if maxsplit == 0 then
      table.insert(t, string.sub(s, curpos - patsz - 1))
    end
  end
  return t
end

function isAlive(apikey, feed)
	local response = http.request {
	method='get',
	url = 'http://api.cosm.com/v2/feeds/'..feed..'.xml',
	headers = { ["X-PachubeApiKey"] = tostring(apikey) } }
	local condition = xpath.selectNodes(lom.parse(response.content), '//status')[1]
	
	return condition[1]
end

return { read_current = read_current, read_24h = read_24h, list_datastreams = list_datastreams, isAlive = isAlive }
