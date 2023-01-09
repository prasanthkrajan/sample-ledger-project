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

		context 'when ledger data is empty' do
			let(:data) { [] }

			it 'returns 0' do
				expect(subject).to eql('USD 0')
			end
		end

		context 'when data has a valid list of amount and belong to same currency' do
			let(:data) do
				[
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
			end

			it 'returns the correct total amount' do
				expect(subject).to eql('USD 63.64')
			end
		end

		context 'when data has a valid list of amount and belong different currencies', vcr: 'services/ledger_data_calculator/total_amount/convert_ok' do
			let(:data) do
				[
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
			end

			it 'returns the correct total amount' do
				expect(subject).to eql('USD 5865.93')
			end
		end

		context 'when data has invalid currencies', vcr: 'services/ledger_data_calculator/total_amount/convert_invalid_currency' do
			let(:data) do
				[
					{
            "amount" => 23.24,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "Gas bill",
            "created_at" => "2022-01-31 05:29:55 -0400"
          },
          {
            "amount" => 50,
            "currency" => "ABC",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          },
          {
            "amount" => 10,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          }
	      ]
			end

			it 'coerces invalid currency to 0 and performs the math' do
				expect(subject).to eql('USD 33.24')
			end
		end

		context 'when data has null values as amount' do
			let(:data) do
				[
					{
            "amount" => 23.24,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "Gas bill",
            "created_at" => "2022-01-31 05:29:55 -0400"
          },
          {
            "amount" => 50,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          },
          {
            "amount" => nil,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          }
	      ]
			end

			it 'coerces null amount to 0 and performs the math' do
				expect(subject).to eql('USD 73.24')
			end
		end

		context 'when data has string values as amount' do
			let(:data) do
				[
					{
            "amount" => 23.24,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "Gas bill",
            "created_at" => "2022-01-31 05:29:55 -0400"
          },
          {
            "amount" => '50',
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          },
          {
            "amount" => 'random-amount',
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          }
	      ]
			end

			it 'converts string value to integer and performs the math' do
				expect(subject).to eql('USD 73.24')
			end
		end

		context 'when data has string long decimal number as amount' do
			let(:data) do
				[
					{
            "amount" => 23.2403939494,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "Gas bill",
            "created_at" => "2022-01-31 05:29:55 -0400"
          },
          {
            "amount" => 50,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          },
          {
            "amount" => '5.303049492',
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          }
	      ]
			end

			it 'performs the math and rounds off the amount to 2 decimal place' do
				expect(subject).to eql('USD 78.54')
			end
		end

		context 'when data has missing keys' do
			let(:data) do
				[
					{
            "amount" => 23.50,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "Gas bill",
            "created_at" => "2022-01-31 05:29:55 -0400"
          },
          {
            "currency" => "USD",
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          },
          {
            "amount" => 15.30,
            "is_credit" => false,
            "description" => "ﾔﾏﾀﾞｶｲｼｬ",
            "created_at" => "2022-01-31 14:29:55 +0900"
          }
	      ]
			end

			it 'ignores data without amount or currency and performs the math' do
				expect(subject).to eql('USD 23.50')
			end
		end

		context 'when different currency is preferred' do
			let(:calculator) { described_class.new(data, 'JPY') }

			context 'and data has a valid list of amount', vcr: 'services/ledger_data_calculator/total_amount/preferred_currency_valid_data_ok' do
				let(:data) do
					[
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
				end

				it 'returns the correct total amount' do
					expect(subject).to eql('JPY 87.00')
				end
			end

			context 'and ledger data is null' do
				let(:data) { }

				it 'returns 0' do
					expect(subject).to eql('JPY 0')
				end
			end

			context 'and ledger data is empty' do
				let(:data) { [] }

				it 'returns 0' do
					expect(subject).to eql('JPY 0')
				end
			end
		end
	end
end