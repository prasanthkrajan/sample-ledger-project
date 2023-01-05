require "rails_helper"

RSpec.describe LedgerApiDataPresenter do
  let(:presenter) { described_class.new(api_endpoint) }

  describe '#formatted_data' do
    subject { presenter.formatted_data }
    let(:api_endpoint) { }
    let(:valid_data_format) do
      {
        data: [
          { 
            :amount => "USD$ 23.24", 
            :datetime => "2022-01-31 05:29:55 -0400", 
            :description => "Gas bill"
          }, 
          { 
            :amount => "JPY$ 4637", 
            :datetime => "2022-01-31 14:29:55 +0900", 
            :description => "ﾔﾏﾀﾞｶｲｼｬ"
          }, 
          { 
            :amount => "USD$ -54.18", 
            :datetime => "2022-01-31 05:29:55 -0400", 
            :description => "REF: #121353abf091285ff727a2649e58ddbae2900918376562abeed49276f"
          }, 
          {
            :amount => "USD$ -51.51", 
            :datetime => "2022-01-31 05:29:55 -0500", 
            :description => nil
          }, 
          {
            :amount => "USD$ 27.7", 
            :datetime => "2022-01-31 05:29:55 -0600", 
            :description => "U+1F32D"
          }, 
          { 
            :amount => "JPY$ 5354", 
            :datetime => "2022-01-31 05:29:55 +0900", 
            :description => "https://docbase.ioからのインボイス"
          }, 
          {
            :amount => "USD$ 74.6", 
            :datetime => "2022-01-31 05:29:55 -0400", 
            :description => "Fuel for trip to Steam Offices"
          }, 
          {
            :amount => "USD$ -66.93", 
            :datetime => "2022-01-31 05:29:55 -0400", 
            :description => "Refund"
          }, 
          {
            :amount => "JPY$ -892", 
            :datetime => "2022-01-31 05:29:55 +0900", 
            :description => "払い戻し"
          }, 
          {
            :amount => "KRW$ 29182", 
            :datetime => "2022-01-31 05:29:55 +0900", 
            :description => "전기세"
          }
        ],
        error: nil
      }
    end

    context 'when API endpoint is valid and data is retrievable' do
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
          error: 'API endpoint unavailable'
        }
      end

      before do
        allow_any_instance_of(described_class).to receive(:api_data).and_return(mock_api_data)
      end

      it 'returns API data in expected format' do
        expect(subject).to eql(expected_data_format)
      end
    end

    context 'when interacting with a real valid API endpoint', vcr: 'presenters/ledger_api_data/formatted_data/ok' do
      let(:api_endpoint) { 'https://take-home-test-api.herokuapp.com/invoices' }
      let(:expected_data_format) { valid_data_format }

      it 'returns API data in expected format' do
        expect(subject).to eql(expected_data_format)
      end
    end

    context 'when interacting with a invalid API endpoint', vcr: 'presenters/ledger_api_data/formatted_data/not_ok' do
      let(:api_endpoint) { 'https://take-home-test-api.herokuapp.com/bogative' }
      let(:expected_data_format) do
        {
          data: [],
          error: 'Unable to fetch data due to error 404'
        }
      end

      it 'returns empty API data and error message' do
        expect(subject).to eql(expected_data_format)
      end
    end
  end
end