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
			total_amount += formatted_amount(d)
		end
		
		"USD #{'%.2f' % total_amount}"
	end

	private

	def formatted_amount(data)
		amount = data['amount'].to_f
		amount = -(amount) if data['is_credit']

		return amount if data['currency'] == USD_CURRENCY
		convert_amount(amount, data['currency'])
	end

	def convert_amount(amount, currency)
		return 0 unless currency.present?

		bank = EuCentralBank.new
		bank.update_rates
		Money.default_bank = bank
		begin
			Money.new(amount, currency).exchange_to(USD_CURRENCY).fractional
		rescue
			0
		end
	end
end