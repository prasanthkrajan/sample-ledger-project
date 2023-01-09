require "rails_helper"

RSpec.describe LedgerDataPresenter do
  let(:presenter) { described_class.new(resource) }
  let(:resource)  { create(:ledger) }
  let!(:ledger_entries) do
    [
      create(:ledger_entry, ledger: resource, currency: 'USD'),
      create(:ledger_entry, ledger: resource, currency: 'JPY')
    ]
  end

  describe '#formatted_data' do
    subject { presenter.formatted_data }
    let(:expected_data_format) do
      {
        data: [
          {
            'formatted_amount' => "USD$ 100.00", 
            'description' => "some-description", 
            'datetime' => "2023-01-01 00:00:00 UTC", 
            'currency' => "USD", 
            'amount' => 100.0
          },
          {
            'formatted_amount' => "JPY$ 100.00", 
            'description' => "some-description", 
            'datetime' => "2023-01-01 00:00:00 UTC",
            'currency' => "JPY", 
            'amount' => 100.0
          }
        ],
        error: nil,
        total_amount: "USD 174.00"
      }
    end

    it 'returns the formatted_data with the right keys and data', vcr: 'presenters/ledger_data_presenter/formatted_data/convert_ok' do
      expect(subject.keys).to match_array([:data, :error, :total_amount])
      expect(subject).to eql(expected_data_format)
    end

    context 'when ledger entries is empty' do
      let!(:ledger_entries) { [] }
      let(:expected_data_format) do
        {
          data: [], 
          error: nil, 
          total_amount: "USD 0"
        }
      end

      it 'returns the formatted_data with the right keys and data' do
        expect(subject.keys).to match_array([:data, :error, :total_amount])
        expect(subject).to eql(expected_data_format)
      end
    end

    context 'when ledger entries is null' do
      let!(:ledger_entries) { }
      let(:expected_data_format) do
        {
          data: [], 
          error: nil, 
          total_amount: "USD 0"
        }
      end

      it 'returns the formatted_data with the right keys and data' do
        expect(subject.keys).to match_array([:data, :error, :total_amount])
        expect(subject).to eql(expected_data_format)
      end
    end
  end
end