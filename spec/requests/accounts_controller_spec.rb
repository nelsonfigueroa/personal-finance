# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account Requests', type: :request do
  let!(:user) do
    User.create(email: Faker::Internet.email,
                name: Faker::Name.first_name,
                password: Faker::Internet.password)
  end

  let!(:account) do
    Account.create(name: Faker::Bank.name,
                   user: user)
  end

  before do
    sign_in user
  end

  after do
    Rails.application.reload_routes!
  end

  describe 'GET index' do
    it 'returns 200' do
      get '/accounts'
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET show' do
    it 'returns 200' do
      get "/accounts/#{account.id}"
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end

    it 'redirects if account does not exist' do
      get '/accounts/123456'
      expect(response).to redirect_to(accounts_path)
      follow_redirect!
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET new' do
    it 'returns 200' do
      get '/accounts/new'
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    let(:valid_params) { { account: { name: 'Foo' } } }
    let(:invalid_params) { { account: { name: 123 } } }

    it 'redirects to accounts_path if account is created' do
      post '/accounts', params: valid_params
      expect(response).to redirect_to(accounts_path)
      follow_redirect!
      expect(response).to render_template(:index)
      expect(response.body).to include('Account created')
      expect(response).to have_http_status(:ok)
    end

    it 'renders new if account is not created' do
      post '/accounts', params: invalid_params
      expect(response).to render_template(:new)
      expect(response.body).to include('Name is invalid')
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET edit' do
    it 'returns 200 if account exists' do
      get "/accounts/#{account.id}/edit"
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:ok)
    end

    it 'redirects if account does not exist' do
      get '/accounts/123456/edit'
      expect(response).to redirect_to(accounts_path)
      follow_redirect!
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT update' do
    let(:valid_params) { { account: { name: 'New Name' } } }
    let(:invalid_params) { { account: { name: 123 } } }

    context 'when parameters are invalid' do
      it 'redirects to edit_account_path' do
        put "/accounts/#{account.id}", params: invalid_params
        expect(flash[:alert].empty?).to eq(false)
        expect(response).to redirect_to(edit_account_path(account))
        follow_redirect!
        expect(response).to render_template(:edit)
        expect(response.body).to include('Name is invalid')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when parameters are valid' do
      it 'updates account with new params' do
        put "/accounts/#{account.id}", params: valid_params
        expect(Account.last.name).to eq('New Name')
        expect(response).to redirect_to(account_path(account))
        follow_redirect!
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
