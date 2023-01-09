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

	def index
		@ledgers ||= Ledger.all
	end

	def new
		@ledger = Ledger.new
		@ledger.ledger_entries.build
	end

	def create
		ledger = Ledger.new(ledger_params)
		if ledger.save
			flash[:success] = 'Ledger created successfully'
    else
    	flash[:error] = ledger.errors.full_messages
    end
    redirect_to ledgers_path
	end

	def show
		unless resource.present?
			flash[:error] = "Resource with ID r#{params[:id]} not available"
			redirect_to ledgers_path
		end
		# redirect_to ledgers_path
		# @ledger = LedgerDataPresenter.new(resource).formatted_data
	end

	private

	def csv_data
		return [] if params[:csv_data].is_a?(String)

		Array(params[:csv_data])
	end

	def ledger_params
    params.require(:ledger).permit(:title, ledger_entries_attributes: [:amount, :currency, :description, :is_credit])
  end

  def resource
  	@resource ||= Ledger.find(params[:id]) rescue nil
  end
end
