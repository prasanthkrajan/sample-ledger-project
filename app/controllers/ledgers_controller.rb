class LedgersController < ApplicationController
	API_ENDPOINT = ENV['API_ENDPOINT']

	def my_ledger
		@my_ledger ||= LedgerApiDataPresenter.new(API_ENDPOINT).formatted_data
	end

	def export
		csv_data = LedgerDataCsvHandler.new(csv_data: params[:csv_data], csv_filename: params[:csv_filename]).generate_csv_data
		send_data(
			csv_data[:data], 
			type: csv_data[:type], 
			disposition: csv_data[:disposition], 
			filename: csv_data[:filename]
		)
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
			flash[:error] = "Resource with ID #{params[:id]} not available"
			redirect_to ledgers_path
			return
		end
		@ledger = LedgerDataPresenter.new(resource).formatted_data
	end

	private

	def ledger_params
    params.require(:ledger).permit(:title, ledger_entries_attributes: [:amount, :currency, :description])
  end

  def resource
  	@resource ||= Ledger.find(params[:id]) rescue nil
  end
end
