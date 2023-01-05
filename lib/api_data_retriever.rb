class ApiDataRetriever
	def self.call(endpoint)
		uri = URI(endpoint)
		response = Net::HTTP.get_response(uri)
		response.is_a?(Net::HTTPSuccess) ? { data: JSON.parse(response.body) } : { error: "Unable to fetch data due to error #{response.code}"}
	end
end