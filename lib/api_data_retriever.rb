class ApiDataRetriever
	def self.call(endpoint)
		uri = URI(endpoint)
		response = Net::HTTP.get_response(uri)
		if response.is_a?(Net::HTTPSuccess)
			parsed_data = begin
			  JSON.parse(response.body)
			rescue JSON::ParserError
			  []
			end
			{ data: parsed_data }
		else
			{ error: "Unable to fetch data due to error #{response.code}"}
		end
	end
end