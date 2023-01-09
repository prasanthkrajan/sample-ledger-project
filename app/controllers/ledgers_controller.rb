require 'csv'

class LedgersController < ApplicationController
	API_ENDPOINT = 'https://take-home-test-api.herokuapp.com/invoices'

	before_action :prepare_ledger_entries_data, only: [:create]

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
		Ledger.create(ledger_params);   
    redirect_to ledgers_path
	end

	private

	def csv_data
		return [] if params[:csv_data].is_a?(String)

		Array(params[:csv_data])
	end

	def ledger_params
    params.require(:ledger).permit(:title, ledger_entries_attributes: [:amount, :currency, :description, :is_credit])
  end

  def prepare_ledger_entries_data
  	params['ledger']['ledger_entries_attributes'].each do |params|
  		is_credit = params[1]['amount'].to_f.negative? ? true : false
  		params[1]['is_credit'] = is_credit
  	end
  end
end
