require "rails_helper"

RSpec.describe LedgerDataPresenter do
  let(:presenter)    { described_class.new(resource) }
  let(:resource)     { create(:ledger) }
  let!(:ledger_entries) do
    [
      create(:ledger_entry, ledger: resource, currency: 'USD'),
      create(:ledger_entry, ledger: resource, currency: 'JPY')
    ]
  end

  describe '#formatted_ledger_data' do
    subject { presenter.send(:formatted_ledger_data) }

    let(:expected_data) do
      [
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
      ]
    end

    it 'returns the data in right format and keys' do
      expect(subject).to eql(expected_data)
    end  

    context 'when ledger entries is empty' do
      let!(:ledger_entries) { [] }

      it 'returns empty' do
        expect(subject).to be_empty
      end  
    end

    context 'when ledger entries is null' do
      let!(:ledger_entries) { }

      it 'returns empty' do
        expect(subject).to be_empty
      end  
    end
  end
end