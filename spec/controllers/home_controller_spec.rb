require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe '#index' do
    it 'respnods with success' do
      get :index

      expect(response).to be_success
      expect(response.body).to eq 'ok'
    end
  end
end
