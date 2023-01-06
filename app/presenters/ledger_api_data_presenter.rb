class LedgerApiDataPresenter
	attr_accessor :api_endpoint

	def initialize(api_endpoint)
		self.api_endpoint = api_endpoint
	end

	def formatted_data
		{
			data: formatted_ledger_data,
			error: formatted_error
		}
	end

	private

	def api_data
		@api_data ||= ApiDataRetriever.call(api_endpoint)
	end

	def formatted_ledger_data
		return [] unless api_data && api_data[:data].present?

		arr = []
		api_data[:data].each do |data|
			arr << {
				amount: format_amount(data),
				description: data['description'],
				datetime: data['created_at']
			}
		end
		arr
	end

	def format_amount(data)
		is_credit = data['is_credit'] ? '-' : nil
		"#{data['currency']}$ #{is_credit}#{data['amount']}"
	end

	def formatted_error
		return unless api_data[:error].present?

		api_data[:error]
	end
end