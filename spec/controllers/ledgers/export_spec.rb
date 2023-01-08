require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
  render_views

  describe "POST export" do
    subject(:response) { post :export, params: post_params }
    let(:base_post_params) do
      {
        format: 'csv',
        csv_filename: 'My Ledger - current-datetime'
      }
    end
    let(:post_params) { base_post_params.merge!(additional_post_params) }
    let(:additional_post_params) { {} }

    context 'when post params has valid CSV data' do
      let(:additional_post_params) do
        {
          csv_data: [
            { 
              'amount' => "USD$ 23.24", 
              'datetime' => "2022-01-31 05:29:55 -0400", 
              'description' => "Gas bill"
            }, 
            { 
              'amount' => "JPY$ 4637", 
              'datetime' => "2022-01-31 14:29:55 +0900", 
              'description' => "ﾔﾏﾀﾞｶｲｼｬ"
            }
          ]
        }
      end

      it 'generates CSV successfully' do
        expect(response.parsed_body.lines.count).to eql(3)
        expect(response.parsed_body.lines[0]).to eql("Amount,Description,Datetime\n")
        expect(response.parsed_body.lines[1]).to eql("USD$ 23.24,Gas bill,2022-01-31 05:29:55 -0400\n")
        expect(response.parsed_body.lines[2]).to eql("JPY$ 4637,ﾔﾏﾀﾞｶｲｼｬ,2022-01-31 14:29:55 +0900\n",)
      end
    end

    context 'when post params has empty CSV data' do
      let(:additional_post_params) do
        {
          csv_data: []
        }
      end

      it 'generates CSV successfully without any rows, and just headers' do
        expect(response.parsed_body.lines.count).to eql(1)
        expect(response.parsed_body.lines[0]).to eql("Amount,Description,Datetime\n")
      end
    end

    context 'when post params has null CSV data' do
      let(:additional_post_params) do
        {
          csv_data: nil
        }
      end

      it 'generates CSV successfully without any rows, and just headers' do
        expect(response.parsed_body.lines.count).to eql(1)
        expect(response.parsed_body.lines[0]).to eql("Amount,Description,Datetime\n")
      end
    end

    context 'when post params does not have the csv_data key' do
      it 'generates CSV successfully without any rows, and just headers' do
        expect(response.parsed_body.lines.count).to eql(1)
        expect(response.parsed_body.lines[0]).to eql("Amount,Description,Datetime\n")
      end
    end
  end
end