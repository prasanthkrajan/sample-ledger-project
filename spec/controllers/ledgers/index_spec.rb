require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
  render_views

  describe "GET index" do
    subject { get :index }

    it "renders the index template" do
      expect(subject).to render_template(:index)
    end

    context 'when data is retrieved successfully from API' do
      let(:mock_ledger_data) do
        [
          {
            amount: 'US$ -23.24',
            description: 'Test Description 10',
            datetime: '2022-01-31 05:29:55 UTC'
          },
          {
            amount: 'US$ -46.37',
            description: 'Test Description 9',
            datetime: '2022-01-30 05:29:55 UTC'
          },
          {
            amount: 'US$ 54.18',
            description: 'Test Description 8',
            datetime: '2022-01-29 05:29:55 UTC'
          },
          {
            amount: 'US$ 51.51',
            description: 'Test Description 7',
            datetime: '2022-01-28 05:29:55 UTC'
          },
          {
            amount: 'US$ -27.7',
            description: 'Test Description 6',
            datetime: '2022-01-27 05:29:55 UTC'
          },
          {
            amount: 'US$ -53.54',
            description: 'Test Description 5',
            datetime: '2022-01-26 05:29:55 UTC'
          },
          {
            amount: 'US$ -74.6',
            description: 'Test Description 4',
            datetime: '2022-01-25 05:29:55 UTC'
          },
          {
            amount: 'US$ 66.93',
            description: 'Test Description 3',
            datetime: '2022-01-24 05:29:55 UTC'
          },
          {
            amount: 'US$ 8.92',
            description: 'Test Description 2',
            datetime: '2022-01-23 05:29:55 UTC'
          },
          {
            amount: 'US$ -23.24',
            description: 'Test Description 1',
            datetime: '2022-01-22 05:29:55 UTC'
          }
        ]
      end
      let(:mock_api_data) { {data: mock_ledger_data} }

      before do
        allow_any_instance_of(described_class).to receive(:data_from_api).and_return(mock_api_data)
      end

      let(:expected_total_entries_count) { mock_ledger_data.count }

      it 'displays the data correctly' do
        expect(response.body).to include("Total Entries: #{expected_total_entries_count}")
      end
    end

    context 'when data is not retrieved successfully from API' do
      let(:error_from_api) { 'API endpoint down'}
      let(:mock_api_data)  { {error: error_from_api} }

      it 'displays the data correctly' do
        expect(response.body).to include(error_from_api)
        expect(response.body).not_to include('Total Entries')
      end

      context 'when error key is not present' do
        let(:mock_api_data)  { }

        it 'displays default error message' do
          expect(response.body).not_to include('Unable to fetch data from API')
        end
      end
    end
  end
end
