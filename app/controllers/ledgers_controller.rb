require 'csv'

class LedgersController < ApplicationController
	API_ENDPOINT = 'https://take-home-test-api.herokuapp.com/invoices'

	def my_ledger
		@my_ledger ||= LedgerApiDataPresenter.new(API_ENDPOINT).formatted_data
	end

	def export
		csv_string = CSV.generate do |csv|
			csv << ['Amount', 'Description', 'Datetime']
      csv_data.each do |t|
     		csv << [t['amount'], t['description'], t['datetime']]
      end             
    end           
    send_data csv_string,
    type: 'text/csv; charset=iso-8859-1; header=present',
    disposition: 'attachment', filename: "#{params[:csv_filename]}.csv"
	end

	private

	def csv_data
		return [] if params[:csv_data].is_a?(String)

		Array(params[:csv_data])
	end
end
