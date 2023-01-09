require 'csv'

class LedgerDataCsvHandler
	attr_accessor :csv_data, :csv_filename

	def initialize(csv_data:, csv_filename:)
		self.csv_data = csv_data
		self.csv_filename = csv_filename || 'Exported_Ledger'
	end

	def generate_csv_data
		csv_string = CSV.generate do |csv|
			csv << headers
      sanitized_csv_data.each do |t|
     		csv << [t['formatted_amount'], t['currency'], t['amount'], t['description'], t['datetime']]
      end             
    end           
    base_csv_data.merge(data: csv_string)
	end

	private

	def sanitized_csv_data
		return [] if csv_data.is_a?(String)

		Array(csv_data)
	end

	def base_csv_data
		{
			type: 'text/csv; charset=iso-8859-1; header=present',
			disposition: 'attachment',
			filename: "#{csv_filename}.csv"
		}
	end

	def headers
		['Formatted Amount', 'Currency', 'Amount', 'Description', 'Datetime']
	end
end