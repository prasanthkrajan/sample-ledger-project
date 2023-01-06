class LedgersController < ApplicationController
	API_ENDPOINT = 'https://take-home-test-api.herokuapp.com/invoices'

	def my_ledger
		@my_ledger ||= LedgerApiDataPresenter.new(API_ENDPOINT).formatted_data
	end
end
