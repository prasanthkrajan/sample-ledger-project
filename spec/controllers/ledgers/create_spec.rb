require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
  render_views

  describe 'POST create' do
    subject(:response) { post :create, params: create_params }

    context 'when a valid create params is passed' do
      let(:create_params) do
        {
          'ledger' => {
            'title' => 'Valid Ledger Title',
            'ledger_entries_attributes' => {
              '0' => {
                'currency' => 'USD',
                'amount' => '100',
                'description' => 'Entry One'
              },
              '1' => {
                'currency' => 'USD',
                'amount' => '-30',
                'description' => 'Entry Two'
              }
            }
          }
        }
      end

      it 'create ledger and its entries successfully' do
        expect { subject }.to change{Ledger.count}.from(0).to(1)
        ledger = Ledger.last
        ledger_entries = ledger.ledger_entries
        expect(ledger_entries.count).to eql(2)
        expect(ledger_entries.first.description).to eql('Entry One')
        expect(ledger_entries.first.is_credit).to eql(false)
        expect(ledger_entries.last.description).to eql('Entry Two')
        expect(ledger_entries.last.is_credit).to eql(true)
      end
    end
  end
end