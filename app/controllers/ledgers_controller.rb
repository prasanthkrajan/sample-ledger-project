class LedgersController < ApplicationController
	API_ENDPOINT = 'https://take-home-test-api.herokuapp.com/invoices'

	def index
		@my_ledger ||= LedgerApiDataPresenter.new(API_ENDPOINT).formatted_data
	end
end
