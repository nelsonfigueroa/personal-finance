# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account Requests', type: :request do
  let(:user) do
    User.create(email: Faker::Internet.email,
                name: Faker::Name.first_name,
                password: Faker::Internet.password)
  end

  let(:account) do
    Account.create(name: Faker::Alphanumeric.alpha(number: 40),
                   user: user)
  end

  let(:statement) do
    Statement.create(balance: Faker::Commerce.price(range: 0..100_000.0),
                     date: Faker::Date.in_date_period(year: 2018, month: 2),
                     account: account)
  end

  before do
    sign_in user
  end

  describe 'GET index' do
    before do
      get '/accounts'
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns @accounts' do
      expect(assigns(:accounts)).to eq(user.accounts)
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET show' do
    context 'if account exists' do
      before do
        get "/accounts/#{account.id}"
      end

      it 'renders show template' do
        expect(response).to render_template(:show)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'assigns @statements' do
        expect(assigns(:statements)).to eq(account.statements)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if account does not exist' do
      before do
        get '/accounts/123456'
      end

      it 'redirects to accounts_path' do
        expect(response).to redirect_to(accounts_path)
      end

      it 'renders index template' do
        follow_redirect!
        expect(response).to render_template(:index)
      end

      it 'returns 302 status before redirect' do
        expect(response).to have_http_status(:found)
      end

      it 'returns 200 status after redirect' do
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET new' do
    it 'renders new template' do
      get '/accounts/new'
      expect(response).to render_template(:new)
      expect(assigns(:account)).to_not eq(nil)
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

    it 'renders new template if account is not created' do
      post '/accounts', params: invalid_params
      expect(response).to render_template(:new)
      expect(response.body).to include('Name is invalid')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET edit' do
    it 'renders edit template if account exists' do
      get "/accounts/#{account.id}/edit"
      expect(response).to render_template(:edit)
      expect(assigns(:account)).to eq(account)
      expect(response).to have_http_status(:ok)
    end

    it 'redirects and renders index template if account does not exist' do
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

    context 'when parameters are valid' do
      it 'updates account with new params and renders show template' do
        put "/accounts/#{account.id}", params: valid_params
        expect(Account.last.name).to eq('New Name')
        expect(response).to redirect_to(account_path(account))
        follow_redirect!
        expect(response).to render_template(:show)
        expect(assigns(:account)).to eq(account)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when parameters are invalid' do
      it 'redirects to edit_account_path and renders edit template' do
        put "/accounts/#{account.id}", params: invalid_params
        expect(flash[:alert].empty?).to eq(false)
        expect(response).to redirect_to(edit_account_path(account))
        follow_redirect!
        expect(response).to render_template(:edit)
        expect(response.body).to include('Name is invalid')
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
