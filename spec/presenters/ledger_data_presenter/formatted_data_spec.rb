require "rails_helper"

RSpec.describe LedgerDataPresenter do
  let(:presenter) { described_class.new(resource) }
  let(:resource)  { create(:ledger) }

  describe '#formatted_data' do
    subject { presenter.formatted_data }

    it 'returns the formatted_data with the right keys' do
      expect(subject.keys).to match_array([:data, :error, :total_amount])
    end
  end
end