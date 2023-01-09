class LedgerDataPresenter
	attr_accessor :resource, :ledger_entries

	def initialize(resource)
		self.resource = resource
		self.ledger_entries = resource.try(:ledger_entries)
	end

	def formatted_data
		{
			data: formatted_ledger_data,
			error: formatted_error,
			total_amount: LedgerDataCalculator.new(formatted_ledger_data).total_amount,
			title: ledger_title
		}
	end

	private

	def formatted_ledger_data
		return [] unless ledger_entries.present?

		arr = []
		ledger_entries.each do |data|
			arr << {
				'formatted_amount' => format_amount(data),
				'description' => data.description,
				'datetime' => data.created_at.to_s,
				'currency' => data.currency,
				'amount' => data.amount
			}
		end
		arr
	end

	def format_amount(data)
		"#{data.currency}$ #{'%.2f' % data.amount}"
	end

	def formatted_error
		return 'Resource not available' unless resource.present?
	end

	def ledger_title
		resource.try(:title)
	end
end