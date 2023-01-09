require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
  render_views

  describe 'GET show' do
    subject(:response) { get :show, params: { id: resource_id } }
    let(:resource_id)  { resource.id }
    let!(:resource)    { create(:ledger) }

    it 'renders the show template' do
      expect(subject).to render_template(:show)
    end
  end
end