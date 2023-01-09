require "rails_helper"
require 'pry'
RSpec.describe LedgerApiDataPresenter do
	let(:presenter) { described_class.new(api_endpoint) }

	describe '#formatted_data' do
		subject { presenter.formatted_data }
		let(:api_endpoint) { }
		let(:valid_data_format) do
			{
				data: [
					{ 
						'formatted_amount' => "USD$ 23.24", 
						'datetime' => "2022-01-31 05:29:55 -0400", 
						'description' => "Gas bill",
						'currency' => "USD",
						'amount' => 23.24
					}, 
					{ 
						'formatted_amount' => "JPY$ 4637.00", 
						'datetime' => "2022-01-31 14:29:55 +0900", 
						'description' => "ﾔﾏﾀﾞｶｲｼｬ",
						'currency' => "JPY",
						'amount' => 4637
					}, 
					{ 
						'formatted_amount' => "USD$ -54.18", 
						'datetime' => "2022-01-31 05:29:55 -0400", 
						'description' => "REF: #121353abf091285ff727a2649e58ddbae2900918376562abeed49276f",
						'currency' => "USD",
						'amount' => -54.18
					}, 
					{
						'formatted_amount' => "USD$ -51.51", 
						'datetime' => "2022-01-31 05:29:55 -0500", 
						'description' => nil,
						'currency' => "USD",
						'amount' => -51.51
					}, 
					{
						'formatted_amount' => "USD$ 27.70", 
						'datetime' => "2022-01-31 05:29:55 -0600", 
						'description' => "U+1F32D",
						'currency' => "USD",
						'amount' => 27.7
					}, 
					{ 
						'formatted_amount' => "JPY$ 5354.00", 
						'datetime' => "2022-01-31 05:29:55 +0900", 
						'description' => "https://docbase.ioからのインボイス",
						'currency' => "JPY",
						'amount' => 5354
					}, 
					{
						'formatted_amount' => "USD$ 74.60", 
						'datetime' => "2022-01-31 05:29:55 -0400", 
						'description' => "Fuel for trip to Steam Offices",
						'currency' => "USD",
						'amount' => 74.6
					}, 
					{
						'formatted_amount' => "USD$ -66.93", 
						'datetime' => "2022-01-31 05:29:55 -0400", 
						'description' => "Refund",
						'currency' => "USD",
						'amount' => -66.93
					}, 
					{
						'formatted_amount' => "JPY$ -892.00", 
						'datetime' => "2022-01-31 05:29:55 +0900", 
						'description' => "払い戻し",
						'currency' => "JPY",
						'amount' => -892
					}, 
					{
						'formatted_amount' => "KRW$ 29182.00", 
						'datetime' => "2022-01-31 05:29:55 +0900", 
						'description' => "전기세",
						'currency' => "KRW",
						'amount' => 29182
					}
				],
				error: nil,
				total_amount: 'USD 9183.92',
				title: 'My Ledger'
			}
		end
		let(:expected_data_keys) { [:data, :error, :total_amount, :title] }

		context 'when API endpoint is valid and data is retrievable', vcr: 'presenters/ledger_api_data/formatted_data/converts_mock_data_ok' do
			let(:expected_data_format) { valid_data_format }

			let(:mock_api_data) do
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
							"is_credit" => true,
							"description" => "REF: #121353abf091285ff727a2649e58ddbae2900918376562abeed49276f",
							"created_at" => "2022-01-31 05:29:55 -0400"
						},
						{
							"amount" => 51.51,
							"currency" => "USD",
							"is_credit" => true,
							"created_at" => "2022-01-31 05:29:55 -0500"
						},
						{
							"amount" => 27.7,
							"currency" => "USD",
							"is_credit" => false,
							"description" => "U+1F32D",
							"created_at" => "2022-01-31 05:29:55 -0600"
						},
						{
							"amount" => 5354,
							"currency" => "JPY",
							"is_credit" => false,
							"description" => "https://docbase.ioからのインボイス",
							"created_at" => "2022-01-31 05:29:55 +0900"
						},
						{
							"amount" => 74.6,
							"currency" => "USD",
							"is_credit" => false,
							"description" => "Fuel for trip to Steam Offices",
							"created_at" => "2022-01-31 05:29:55 -0400"
						},
						{
							"amount" => 66.93,
							"currency" => "USD",
							"is_credit" => true,
							"description" => "Refund",
							"created_at" => "2022-01-31 05:29:55 -0400"
						},
						{
							"amount" => 892,
							"currency" => "JPY",
							"is_credit" => true,
							"description" => "払い戻し",
							"created_at" => "2022-01-31 05:29:55 +0900"
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

			before do
				allow_any_instance_of(described_class).to receive(:api_data).and_return(mock_api_data)
			end

			it 'returns API data in expected format' do
				expect(subject.keys).to match_array(expected_data_keys)
				expect(subject).to eql(expected_data_format)
			end
		end

		context 'when API endpoint is down or invalid' do
			let(:mock_api_data) do
				{
					error: 'API endpoint unavailable'
				}
			end
			let(:expected_data_format) do
				{
					data: [],
					error: 'API endpoint unavailable',
					total_amount: 'USD 0',
					title: 'My Ledger'
				}
			end

			before do
				allow_any_instance_of(described_class).to receive(:api_data).and_return(mock_api_data)
			end

			it 'returns API data in expected format' do
				expect(subject.keys).to match_array(expected_data_keys)
				expect(subject).to eql(expected_data_format)
			end
		end

		context 'when interacting with a real valid API endpoint', vcr: 'presenters/ledger_api_data/formatted_data/ok' do
			let(:api_endpoint) { ENV['API_ENDPOINT'] }
			let(:expected_data_format) { valid_data_format }

			it 'returns API data in expected format' do
				expect(subject.keys).to match_array(expected_data_keys)
				expect(subject).to eql(expected_data_format)
			end
		end

		context 'when interacting with an invalid API endpoint', vcr: 'presenters/ledger_api_data/formatted_data/not_ok' do
			let(:api_endpoint) { 'https://take-home-test-api.herokuapp.com/bogative' }
			let(:expected_data_format) do
				{
					data: [],
					error: 'Unable to fetch data due to error 404',
					total_amount: 'USD 0',
					title: 'My Ledger'
				}
			end

			it 'returns empty API data and error message' do
				expect(subject.keys).to match_array(expected_data_keys)
				expect(subject).to eql(expected_data_format)
			end
		end
	end
end