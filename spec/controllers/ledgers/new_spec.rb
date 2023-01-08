require 'rails_helper'

RSpec.describe LedgersController, type: :controller do
  render_views

  describe 'GET new' do
    subject(:response) { get :new }

    it 'renders the new template' do
      expect(subject).to render_template(:new)
    end
  end
end