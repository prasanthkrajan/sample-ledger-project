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

		context 'when data has a valid list of amount and belong different currencies', vcr: 'services/ledger_data_calculator/total_amount/convert_ok' do
			let(:data) do
				{
					data: [
						{
              "amount" => 23.24,
              "currency" => "USD",
              "is_credit" => false,
              "description" => "Gas bill",
              "created_at" => "2022-01-31 05:29:55 -0400"
            },
            {
              "amount" => 4637,
              "currency" => "JPY",
              "is_credit" => false,
              "description" => "ﾔﾏﾀﾞｶｲｼｬ",
              "created_at" => "2022-01-31 14:29:55 +0900"
            },
            {
              "amount" => 54.18,
              "currency" => "USD",
              "is_credit" => false,
              "description" => "REF: #121353abf091285ff727a2649e58ddbae2900918376562abeed49276f",
              "created_at" => "2022-01-31 05:29:55 -0400"
            },
            {
              "amount" => 51.51,
              "currency" => "USD",
              "is_credit" => false,
              "created_at" => "2022-01-31 05:29:55 -0500"
            },
            {
              "amount" => 29182,
              "currency" => "KRW",
              "is_credit" => false,
              "description" => "전기세",
              "created_at" => "2022-01-31 05:29:55 +0900"
            }
		      ]
				}
			end

			it 'returns the correct total amount' do
				expect(subject).to eql('USD 129.93')
			end
		end
	end
end