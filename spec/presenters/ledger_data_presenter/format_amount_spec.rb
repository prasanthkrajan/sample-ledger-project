require "rails_helper"

RSpec.describe LedgerDataPresenter do
  let(:presenter)    { described_class.new(resource) }
  let(:resource)     { create(:ledger) }

  describe '#format_amount' do
    let(:amount) { 54.50 }
    let(:currency) { 'USD' }
    let(:ledger_entry) { create(:ledger_entry, ledger: resource, amount: amount, currency: currency) }

    subject { presenter.send(:format_amount, ledger_entry) }

    it 'returns the correct formatted amount' do
      expect(subject).to eql('USD$ 54.50')
    end

    context 'when amount is in negative' do
      let(:amount) { -54.50 }

      it 'returns the correct formatted amount' do
        expect(subject).to eql('USD$ -54.50')
      end
    end
  end
end