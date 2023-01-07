require 'csv'

class LedgersController < ApplicationController
	API_ENDPOINT = 'https://take-home-test-api.herokuapp.com/invoices'

	def my_ledger
		@my_ledger ||= LedgerApiDataPresenter.new(API_ENDPOINT).formatted_data
	end

	def export
		@csv_data = params[:csv_data]
		respond_to do |format|
			format.csv do
		    response.headers['Content-Type'] = 'text/csv'
		    response.headers['Content-Disposition'] = 'attachment; filename=ledger.csv'    
		    render :template => "ledgers/export.csv.haml"
			end
		end
	end
end
