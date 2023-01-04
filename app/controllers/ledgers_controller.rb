class LedgersController < ApplicationController
	def index
		@my_ledger ||= data_from_api
	end

	private 

	def data_from_api
	end
end
