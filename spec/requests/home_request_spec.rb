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

  describe 'GET about' do
    before do
      get about_path
    end

    it 'renders about template' do
      expect(response).to render_template('about')
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET dashboard' do
    let!(:user) { create(:user) }
    before do
      sign_in user
      get dashboard_path
    end

    it 'assigns @user' do
      expect(assigns(:user)).to eq(user)
    end
  end
end
