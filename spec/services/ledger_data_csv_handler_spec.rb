require "rails_helper"

RSpec.describe LedgerDataCsvHandler do
	let(:csv_handler) { described_class.new(csv_data: csv_data, csv_filename: csv_filename) }
	let(:csv_data) do
		[
      { 
        'formatted_amount' => "USD$ 23.24", 
        'datetime' => "2022-01-31 05:29:55 -0400", 
        'description' => "Gas bill",
        'currency' => 'USD',
        'amount' => 23.24
      }, 
      { 
        'formatted_amount' => "JPY$ 4637", 
        'datetime' => "2022-01-31 14:29:55 +0900", 
        'description' => "ﾔﾏﾀﾞｶｲｼｬ",
        'currency' => 'JPY',
        'amount' => 4637
      }
    ]
	end
	let(:csv_filename) { 'CSV Ledger' }
	let(:base_expected_csv_data) do
		{
			type: "text/csv; charset=iso-8859-1; header=present",
			disposition: "attachment"
		}
	end
	let(:expected_csv_data) { base_expected_csv_data.merge(additional_csv_data) }

	describe '#generate_csv_data' do
		subject { csv_handler.generate_csv_data }
		let(:additional_csv_data) do
			{
 				filename: "CSV Ledger.csv",
 				data: "Formatted Amount,Currency,Amount,Description,Datetime\nUSD$ 23.24,USD,23.24,Gas bill,2022-01-31 05:29:55 -0400\nJPY$ 4637,JPY,4637,ﾔﾏﾀﾞｶｲｼｬ,2022-01-31 14:29:55 +0900\n"
 			}
		end

		it 'returns a csv data as a hash to be used in controller' do
			expect(subject).to eql(expected_csv_data)
		end

		context 'when csv data is empty' do
			let(:csv_data) { [] }
			let(:additional_csv_data) do
				{
	 				filename: "CSV Ledger.csv",
	 				data: "Formatted Amount,Currency,Amount,Description,Datetime\n"
	 			}
			end

			it 'returns a csv data as a hash to be used in controller' do
				expect(subject).to eql(expected_csv_data)
			end
		end

		context 'when csv data is empty' do
			let(:csv_data) { }
			let(:additional_csv_data) do
				{
	 				filename: "CSV Ledger.csv",
	 				data: "Formatted Amount,Currency,Amount,Description,Datetime\n"
	 			}
			end

			it 'returns a csv data as a hash to be used in controller' do
				expect(subject).to eql(expected_csv_data)
			end
		end

		context 'when csv filename is null' do
			let(:csv_filename) { }
			let(:additional_csv_data) do
				{
	 				filename: "Exported_Ledger.csv",
	 				data: "Formatted Amount,Currency,Amount,Description,Datetime\nUSD$ 23.24,USD,23.24,Gas bill,2022-01-31 05:29:55 -0400\nJPY$ 4637,JPY,4637,ﾔﾏﾀﾞｶｲｼｬ,2022-01-31 14:29:55 +0900\n"
	 			}
			end

			it 'returns a csv data as a hash to be used in controller' do
				expect(subject).to eql(expected_csv_data)
			end
		end
	end
end