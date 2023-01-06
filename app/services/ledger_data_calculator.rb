class LedgerDataCalculator
	attr_accessor :data

	def initialize(ledger_data)
		self.data = ledger_data ? Array(ledger_data[:data]) : []
	end

	def total_amount
		return 'USD 0' unless data.present?

		arr = []
		data.each do |d|
			arr << if d['is_credit']
				-(d['amount'])
			else
				d['amount']
			end
		end
		
		"USD #{arr.sum}"
	end
end