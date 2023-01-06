require "rails_helper"

RSpec.describe LedgerApiDataPresenter do
  let(:api_endpoint) { 'some-api-endpoint' }
  let(:presenter)    { described_class.new(api_endpoint) }

  describe '#format_amount' do
    subject { presenter.send(:format_amount, ledger_data) }

    let(:ledger_data) do 
      {
        "amount" => 23.24,
        "currency" => "USD",
        "is_credit" => is_credit,
        "description" => "Gas bill",
        "created_at" => "2022-01-31 05:29:55 -0400"
      }
    end

    context 'when ledger data is credit is true' do
      let(:is_credit) { true }

      it 'returns formatted amount with negative' do
        expect(subject).to eql('USD$ -23.24')
      end
    end

    context 'when ledger data is credit is false' do
      let(:is_credit) { false }

      it 'returns formatted amount without negative' do
        expect(subject).to eql('USD$ 23.24')
      end
    end

    context 'when some keys in the hash are missing' do
      let(:ledger_data) do 
        {
          "amount" => 23.24,
          "description" => "Gas bill",
          "created_at" => "2022-01-31 05:29:55 -0400"
        }
      end

      it 'returns formatted amount, omitting some details' do
        expect(subject).to eql('$ 23.24')
      end
    end
  end
end