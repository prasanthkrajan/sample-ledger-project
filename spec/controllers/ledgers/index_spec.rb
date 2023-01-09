require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
  render_views

  describe 'GET index' do
    subject(:response) { get :index }

    it 'renders the index template' do
      expect(subject).to render_template(:index)
    end

    context 'when ledgers are present' do
      let!(:ledgers) do
        [
          create(:ledger, title: 'Ledger One'),
          create(:ledger, title: 'Ledger Two'),
          create(:ledger, title: 'Ledger Three')
        ]
      end

      it 'displays the data correctly' do
        expect(response.body).to include("Total Ledgers: #{ledgers.count + 1}")
        expect(response.body).to have_link('Create New Ledger')
        expect(response.body).to have_link('Ledger One')
        expect(response.body).to have_link('Ledger Two')
        expect(response.body).to have_link('Ledger Three')
      end
    end

    context 'when ledgers are not present' do
      it 'displays the data correctly' do
        expect(response.body).to include("Total Ledgers: 1")
        expect(response.body).to have_link('Create New Ledger')
      end
    end
  end
end