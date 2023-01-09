require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
	render_views

	describe 'POST create' do
		subject(:response) { post :create, params: create_params }
		let(:ledger_title) { 'Valid Ledger Title' }
		let(:ledger_entries_attributes) do
			{
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
		end
		let(:create_params) do
			{
				'ledger' => {
					'title' => ledger_title,
					'ledger_entries_attributes' => ledger_entries_attributes
				}
			}
		end

		context 'when a valid create params is passed' do
			it 'create ledger and its entries successfully' do
				expect { subject }.to change {Ledger.count}.from(0).to(1)
				ledger = Ledger.last
				ledger_entries = ledger.ledger_entries
				expect(ledger.title).to eql(ledger_title)
				expect(ledger_entries.count).to eql(2)
				expect(ledger_entries.first.description).to eql('Entry One')
				expect(ledger_entries.last.description).to eql('Entry Two')
			end
		end

		context 'when ledger title is null' do
			let(:ledger_title) { }

			it 'doest not create ledger and its entries' do
				expect { subject }.not_to change {Ledger.count}
				expect(LedgerEntry.all).to be_empty
			end
		end

		context 'when ledger title is empty string' do
			let(:ledger_title) { '' }

			it 'does not create ledger and its entries' do
				expect { subject }.not_to change {Ledger.count}
				expect(LedgerEntry.all).to be_empty
			end
		end

		context 'when ledger entries atrributes are empty' do
			let(:ledger_entries_attributes) do
				{
					'0' => {
						'currency' => '',
						'amount' => '',
						'description' => ''
					},
					'1' => {
						'currency' => '',
						'amount' => '',
						'description' => ''
					}
				}
			end

			it 'does not create ledger and its entries' do
				expect { subject }.not_to change {Ledger.count}
				expect(LedgerEntry.all).to be_empty
			end
		end
	end
end