#encoding: utf-8 
require "rails_helper"

RSpec.describe ApiDataRetriever do
  let(:api_endpoint) { 'https://take-home-test-api.herokuapp.com/invoices' }

  describe '.call' do
    subject { described_class.call(api_endpoint) }

    context 'when endpoint is valid and up and running', vcr: 'lib/api_data_retriever/ok' do
      it 'returns raw data successfully' do
        expect(subject).to eql({
          data: [
            {
              "amount"=>23.24, 
              "currency"=>"USD", 
              "is_credit"=>false, 
              "description"=>"Gas bill", 
              "created_at"=>"2022-01-31 05:29:55 -0400"
            }, 
            {
              "amount"=>4637, 
              "currency"=>"JPY", 
              "is_credit"=>false, 
              "description"=>"ﾔﾏﾀﾞｶｲｼｬ", 
              "created_at"=>"2022-01-31 14:29:55 +0900"
            }, 
            {
              "amount"=>54.18, 
              "currency"=>"USD", 
              "is_credit"=>true, 
              "description"=>"REF: #121353abf091285ff727a2649e58ddbae2900918376562abeed49276f", 
              "created_at"=>"2022-01-31 05:29:55 -0400"
            }, 
            {
              "amount"=>51.51, 
              "currency"=>"USD", 
              "is_credit"=>true, 
              "created_at"=>"2022-01-31 05:29:55 -0500"
            }, 
            {

              "amount"=>27.7, 
              "currency"=>"USD", 
              "is_credit"=>false, 
              "description"=>"U+1F32D", 
              "created_at"=>"2022-01-31 05:29:55 -0600"
            }, 
            {
              "amount"=>5354, 
              "currency"=>"JPY", 
              "is_credit"=>false, 
              "description"=>"https://docbase.ioからのインボイス", 
              "created_at"=>"2022-01-31 05:29:55 +0900"
            }, 
            {

              "amount"=>74.6, 
              "currency"=>"USD", 
              "is_credit"=>false, 
              "description"=>"Fuel for trip to Steam Offices", 
              "created_at"=>"2022-01-31 05:29:55 -0400"
            }, 
            {
              "amount"=>66.93, 
              "currency"=>"USD", 
              "is_credit"=>true, 
              "description"=>"Refund", 
              "created_at"=>"2022-01-31 05:29:55 -0400"
            }, 
            {

              "amount"=>892, 
              "currency"=>"JPY", 
              "is_credit"=>true, 
              "description"=>"払い戻し", 
              "created_at"=>"2022-01-31 05:29:55 +0900"
            }, 
            {

              "amount"=>29182, 
              "currency"=>"KRW", 
              "is_credit"=>false, 
              "description"=>"전기세", 
              "created_at"=>"2022-01-31 05:29:55 +0900"
            }
          ]
        })
      end
    end

    context 'when endpoint is down or not found', vcr: 'lib/api_data_retriever/not_ok' do
      let(:api_endpoint) { 'https://take-home-test-api.herokuapp.com/bogative' }

      it 'returns error' do
        expect(subject).to eql({ error: 'Unable to fetch data due to error 404' })
      end
    end

    context 'when endpoint returns data that cannot be parsed' do
      let(:api_endpoint) { 'some-non-json-api-endpoint' }

      before do
        response = double(body: 'bogative')
        allow(Net::HTTP).to receive(:get_response).with(anything).and_return(response)
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      end

      it 'returns empty array as data' do
        expect(subject).to eql({ data: [] })
      end
    end
  end
end