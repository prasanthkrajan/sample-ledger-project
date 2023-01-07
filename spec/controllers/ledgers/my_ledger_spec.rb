require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
  render_views

  describe "GET my_ledger" do
    subject(:response) { get :my_ledger }

    it "renders the my_ledger template", vcr: 'controllers/ledgers/my_ledger/render_template_ok' do
      expect(subject).to render_template(:my_ledger)
    end

    context 'when data is retrieved successfully from API', vcr: 'controllers/ledgers/my_ledger/ok' do
      let(:expected_total_entries_count) { 10 }

      it 'displays the data correctly' do
        expect(response.body).to include("Total Entries: #{expected_total_entries_count}")
        expect(response.body).to include('table')
      end
    end

    context 'when data is not retrieved successfully from API' do
      before do
        described_class::API_ENDPOINT = 'https://take-home-test-api.herokuapp.com/bogative'
      end

      let(:error_from_api) { 'Unable to fetch data due to error 404'}

      it 'displays the data correctly', vcr: 'controllers/ledgers/my_ledger/not_ok' do
        expect(response.body).to include(error_from_api)
        expect(response.body).not_to include('Total Entries')
        expect(response.body).not_to include('table')
      end
    end

    context 'when error key is not present' do
      before do
        allow_any_instance_of(LedgerApiDataPresenter).to receive(:formatted_data).and_return({ data: [] })
      end

      it 'displays default error message' do
        expect(response.body).to include('Unable to fetch data from API')
      end
    end
  end
end
