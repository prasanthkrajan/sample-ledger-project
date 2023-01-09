class LedgerDataCalculator
	attr_accessor :data, :preferred_currency

	def initialize(ledger_data, preferred_currency = 'USD')
		self.data = ledger_data ? Array(ledger_data) : []
		self.preferred_currency = preferred_currency
	end

	def total_amount
		return default_amount unless data.present?

		total_amount = 0
		data.each do |d|
			total_amount += formatted_amount(d)
		end
		
		"#{preferred_currency} #{'%.2f' % total_amount}"
	end

	private

	def formatted_amount(data)
		amount = data['amount'].to_f
		amount = -(amount) if data['is_credit']

		return amount if data['currency'] == preferred_currency
		convert_amount(amount, data['currency'])
	end

	def convert_amount(amount, currency)
		return 0 unless currency.present?

		bank = EuCentralBank.new
		bank.update_rates
		Money.default_bank = bank
		begin
			Money.new(amount, currency).exchange_to(preferred_currency).fractional
		rescue
			0
		end
	end

	def default_amount
		"#{preferred_currency} 0"
	end
end