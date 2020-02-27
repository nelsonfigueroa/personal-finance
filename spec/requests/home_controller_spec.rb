# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :request do
  describe 'GET index' do
    before(:example) { get root_path }

    it 'gets index page' do
      expect(response).to render_template('index')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET faq' do
    before(:example) { get faq_path }

    it 'gets the faq page' do
      expect(response).to render_template('faq')
      expect(response).to have_http_status(:ok)
    end
  end
end
