# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home Requests', type: :request do
  describe 'GET index' do
    before do
      get root_path
    end

    it 'renders index template' do
      expect(response).to render_template('index')
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end
end
