class LedgerDataCalculator
	USD_CURRENCY = 'USD'
	attr_accessor :data

	def initialize(ledger_data)
		self.data = ledger_data ? Array(ledger_data[:data]) : []
	end

	def total_amount
		return 'USD 0' unless data.present?

		total_amount = 0
		data.each do |d|
			total_amount += converted_amount(d)
		end
		
		"USD #{total_amount}"
	end

	private

	def converted_amount(data)
		amount = if data['is_credit']
			-(data['amount'])
		else
			data['amount']
		end

		return amount if data['currency'] == USD_CURRENCY

		bank = EuCentralBank.new
		bank.update_rates
		Money.default_bank = bank
		Money.new(1, data['currency']).exchange_to(USD_CURRENCY).fractional
	end
end