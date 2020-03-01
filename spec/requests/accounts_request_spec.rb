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
    before do
      get '/accounts/new'
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns unsaved @account' do
      expect(assigns(:account)).to_not eq(nil)
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      let(:valid_params) { { account: { name: 'Foo' } } }
      before do
        post '/accounts', params: valid_params
      end

      it 'redirects to account_path' do
        expect(response).to redirect_to(accounts_path)
      end

      it 'renders index template' do
        follow_redirect!
        expect(response).to render_template(:index)
      end

      it 'includes "Account created" in response body' do
        follow_redirect!
        expect(response.body).to include('Account created')
      end

      it 'returns 302 status before redirect' do
        expect(response).to have_http_status(:found)
      end

      it 'returns 200 status after redirect' do
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when parameters are invalid' do
      let(:invalid_params) { { account: { name: 123 } } }
      before do
        post '/accounts', params: invalid_params
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end

      it 'includes "Name is invalid" in response body' do
        expect(response.body).to include('Name is invalid')
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET edit' do
    context 'if account exists' do
      before do
        get "/accounts/#{account.id}/edit"
      end

      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if account does not exist' do
      before do
        get '/accounts/123456/edit'
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

  describe 'PUT update' do
    context 'when parameters are valid' do
      let(:valid_params) { { account: { name: 'New Name' } } }
      before do
        put "/accounts/#{account.id}", params: valid_params
      end

      it 'updates @account with new params' do
        expect(Account.last.name).to eq('New Name')
      end

      it 'redirects to account_path' do
        expect(response).to redirect_to(account_path(account))
      end

      it 'renders show template' do
        follow_redirect!
        expect(response).to render_template(:show)
      end

      it 'assigns @account in show template' do
        follow_redirect!
        expect(assigns(:account)).to eq(account)
      end

      it 'returns 302 status before redirect' do
        expect(response).to have_http_status(:found)
      end

      it 'returns 200 status after redirect' do
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when parameters are invalid' do
      let(:invalid_params) { { account: { name: 123 } } }
      before do
        put "/accounts/#{account.id}", params: invalid_params
      end

      it 'redirects to edit_account_path' do
        expect(response).to redirect_to(edit_account_path(account))
      end

      it 'renders edit template' do
        follow_redirect!
        expect(response).to render_template(:edit)
      end

      it 'includes "Name is invalid" in response body' do
        follow_redirect!
        expect(response.body).to include('Name is invalid')
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
end
