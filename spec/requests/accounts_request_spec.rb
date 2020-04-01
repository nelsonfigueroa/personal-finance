# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account Requests', type: :request do # rubocop:disable Metrics/BlockLength
  let!(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:statement) { create(:statement, account: account) }

  before do
    sign_in user
  end

  describe 'GET index' do
    let(:net_worth) { user.statements.where(date: Date.today.beginning_of_month..Date.today.end_of_month).sum(:balance) }
    let(:net_worth_change) { net_worth - user.statements.where(date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).sum(:balance) }
    before do
      get '/accounts'
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns @accounts' do
      expect(assigns(:accounts)).to eq(user.accounts)
    end

    it 'assigns @net_worth' do
      expect(assigns(:net_worth)).to eq(net_worth)
    end

    it 'assigns @net_worth_change' do
      expect(assigns(:net_worth_change)).to eq(net_worth_change)
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

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
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
      let(:valid_params) { { account: { name: Faker::Alphanumeric.alpha(number: 40) } } }
      before do
        post '/accounts', params: valid_params
      end

      it 'saves @account' do
        expect(assigns(:account)).to eq(Account.last)
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
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
      let(:invalid_params) { { account: { name: Faker::Number.number(digits: 3) } } }
      before do
        post '/accounts', params: invalid_params
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
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

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
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
      let(:new_name) { Faker::Alphanumeric.alpha(number: 40) }
      let(:valid_params) { { account: { name: new_name } } }
      before do
        put "/accounts/#{account.id}", params: valid_params
      end

      it 'updates @account with new params' do
        expect(Account.last.name).to eq(new_name)
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
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

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
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
