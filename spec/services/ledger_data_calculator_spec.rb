require "rails_helper"

RSpec.describe LedgerDataCalculator do
	let(:calculator) { described_class.new(data) }

	describe '#total_amount' do
		subject { calculator.total_amount }

		context 'when ledger data is null' do
			let(:data) { }

			it 'returns 0' do
				expect(subject).to eql('USD 0')
			end
		end

		context 'when ledger data key is empty' do
			let(:data) { { data: [] } }

			it 'returns 0' do
				expect(subject).to eql('USD 0')
			end
		end

		context 'when ledger data key is null' do
			let(:data) { { data: nil } }

			it 'returns 0' do
				expect(subject).to eql('USD 0')
			end
		end

		context 'when data has a valid list of amount and belong to same curreny' do
			let(:data) do
				{
					data: [
						{
		          "amount" => 23.24,
		          "currency" => "USD",
		          "is_credit" => false,
		          "description" => "Entry 1",
		          "created_at" => "2022-01-31 05:29:55 -0400"
		        },
		      	{
		          "amount" => 50.60,
		          "currency" => "USD",
		          "is_credit" => false,
		          "description" => "Entry 2",
		          "created_at" => "2022-01-31 05:29:55 -0400"
		        },
		        {
		          "amount" => 10.20,
		          "currency" => "USD",
		          "is_credit" => true,
		          "description" => "Entry 2",
		          "created_at" => "2022-01-31 05:29:55 -0400"
		        }
		      ]
				}
			end

			it 'returns the correct total amount' do
				expect(subject).to eql('USD 63.64')
			end
		end

		# context 'when data has a valid list of amount and belong different currencies' do
		# 	let(:data) do
		# 		{
		# 			data: [
		# 				{
		#           "amount" => 23.24,
		#           "currency" => "USD",
		#           "is_credit" => false,
		#           "description" => "Entry 1",
		#           "created_at" => "2022-01-31 05:29:55 -0400"
		#         },
		#       	{
		#           "amount" => 50.60,
		#           "currency" => "USD",
		#           "is_credit" => false,
		#           "description" => "Entry 2",
		#           "created_at" => "2022-01-31 05:29:55 -0400"
		#         },
		#         {
		#           "amount" => 10.20,
		#           "currency" => "USD",
		#           "is_credit" => true,
		#           "description" => "Entry 2",
		#           "created_at" => "2022-01-31 05:29:55 -0400"
		#         }
		#       ]
		# 		}
		# 	end

		# 	it 'returns the correct total amount' do
		# 		expect(subject).to eql('USD 63.64')
		# 	end
		# end
	end
end