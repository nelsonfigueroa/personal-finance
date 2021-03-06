# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Statement Requests', type: :request do
  let!(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:statement) { create(:statement, account: account) }

  let(:date) { Faker::Date.in_date_period(year: 2018, month: 2) }
  let(:balance) { Faker::Commerce.price(range: 0..100_000.0) }

  before do
    sign_in user
  end

  describe 'GET new' do
    context 'if user has a statement for this month' do
      before do
        statement.date = Faker::Date.in_date_period(year: 2020, month: Time.zone.today.month)
        statement.save!
        get "/accounts/#{account.id}/statements/new"
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to account_path of statement' do
        expect(response).to redirect_to(account_path(account))
      end

      it 'renders accounts/show template' do
        follow_redirect!
        expect(response).to render_template('accounts/show')
      end

      it 'returns 302 status before redirect' do
        expect(response).to have_http_status(:found)
      end

      it 'returns 200 status after redirect' do
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if user does not have a statement for this month' do
      before do
        get "/accounts/#{account.id}/statements/new"
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end

      it 'assigns unsaved @statement' do
        expect(assigns(:statement)).to_not eq(nil)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST create' do
    context 'if user already has a statement for this month' do
      let(:date_in_current_month) { Faker::Date.in_date_period(year: 2020, month: Time.zone.today.month) }
      let(:valid_params) { { statement: { balance: balance, date: date_in_current_month } } }
      before do
        statement.date = date_in_current_month
        statement.save!
        post "/accounts/#{account.id}/statements", params: valid_params
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to account_path of statement' do
        expect(response).to redirect_to(account_path(account))
      end

      it 'renders accounts/show template' do
        follow_redirect!
        expect(response).to render_template('accounts/show')
      end

      it 'returns 302 status before redirect' do
        expect(response).to have_http_status(:found)
      end

      it 'returns 200 status after redirect' do
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when parameters are valid' do
      let(:valid_params) { { statement: { balance: balance, date: date } } }
      before do
        post "/accounts/#{account.id}/statements", params: valid_params
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'saves @statement' do
        expect(assigns(:statement)).to eq(Statement.last)
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
      end

      it 'redirects to account_path of statement' do
        expect(response).to redirect_to(account_path(account))
      end

      it 'renders accounts/show template' do
        follow_redirect!
        expect(response).to render_template('accounts/show')
      end

      it 'includes "Statement created" in response body' do
        follow_redirect!
        expect(response.body).to include('Statement created')
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
      let(:invalid_params) { { statement: { balance: Faker::Alphanumeric.alpha(number: 5), date: date } } }
      before do
        post "/accounts/#{account.id}/statements", params: invalid_params
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end

      it 'includes "Balance is not a number" in response body' do
        expect(response.body).to include('Balance is not a number')
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET edit' do
    context 'if statement exists' do
      before do
        get "/accounts/#{account.id}/statements/#{statement.id}/edit"
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it 'assigns @statement' do
        expect(assigns(:statement)).to eq(statement)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if statement does not exist' do
      before do
        get "/accounts/#{account.id}/statements/123456/edit"
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to account_path' do
        expect(response).to redirect_to(account_path(account))
      end

      it 'renders accounts/show template' do
        follow_redirect!
        expect(response).to render_template('accounts/show')
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
      let(:new_balance) { balance }
      let(:valid_params) { { statement: { balance: new_balance, date: date } } }
      before do
        put "/accounts/#{account.id}/statements/#{statement.id}", params: valid_params
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'updates @statement with new params' do
        # added .to_f to fix flaky test
        expect(Statement.last.balance.to_f).to eq(new_balance)
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
      end

      it 'redirects to account_path' do
        expect(response).to redirect_to(account_path(account))
      end

      it 'renders account/show template' do
        follow_redirect!
        expect(response).to render_template('accounts/show')
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
      let(:invalid_params) { { statement: { balance: Faker::String.random, date: date } } }
      before do
        put "/accounts/#{account.id}/statements/#{statement.id}", params: invalid_params
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(user)
      end

      it 'assigns @account' do
        expect(assigns(:account)).to eq(account)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to edit_account_statement_path' do
        expect(response).to redirect_to(edit_account_statement_path(account_id: account.id, statement: statement))
      end

      it 'renders edit template' do
        follow_redirect!
        expect(response).to render_template(:edit)
      end

      it 'includes "Balance is not a number" in response body' do
        follow_redirect!
        expect(response.body).to include('Balance is not a number')
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
