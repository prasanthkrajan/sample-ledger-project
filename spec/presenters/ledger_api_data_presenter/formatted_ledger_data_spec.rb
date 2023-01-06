require "rails_helper"

RSpec.describe LedgerApiDataPresenter do
  let(:api_endpoint) { 'some-api-endpoint' }
  let(:presenter)    { described_class.new(api_endpoint) }

  describe '#formatted_ledger_data' do
    subject { presenter.send(:formatted_ledger_data) }

    before do
      allow(ApiDataRetriever).to receive(:call).with(api_endpoint).and_return(expected_api_data)
    end

    context 'when API data key returns empty array' do
      let(:expected_api_data) { {data: []} }
     
      it 'returns empty' do
        expect(subject).to eql([])
      end
    end

    context 'when API data key returns null' do
      let(:expected_api_data) { {data: nil} }

      it 'returns empty' do
        expect(subject).to eql([])
      end
    end

    context 'when API data return null' do
      let(:expected_api_data) { }

      it 'returns empty' do
        expect(subject).to eql([])
      end
    end

    context 'when API data key has valid data' do
      let(:expected_api_data) do
        {
          data: [{
            "amount" => 23.24,
            "currency" => "USD",
            "is_credit" => false,
            "description" => "Gas bill",
            "created_at" => "2022-01-31 05:29:55 -0400"
          }]
        }
      end

      it 'returns array of valid data' do
        expect(subject).to eql([{:amount=>"USD$ 23.24", :datetime=>"2022-01-31 05:29:55 -0400", :description=>"Gas bill"}])
      end
    end
  end
end