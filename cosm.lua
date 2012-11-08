function read_current(apikey,feed, datastream) 
	local response = http.request {
	method='get',
	url = 'http://api.cosm.com/v2/feeds/'..feed..'/datastreams/'..datastream,
	headers = 
  {
    ["X-PachubeApiKey"] = "aeiS1ETfAjuPiu7Fzq8HIjdh4jOSAKxkYk1RNm9od2ZaTT0g"
  }
}

	return json.parse(response.content).current_value
end

function read_24h(apikey, feed, datastream) 
	local response = http.request {
	method='get',
	url = 'http://api.cosm.com/v2/feeds/'..feed..'/datastreams/'..datastream..'/?duration=24hours&interval=60',
	headers = 
  {
    ["X-PachubeApiKey"] = tostring(apikey)
  }
}

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
	--return debug
		
end
