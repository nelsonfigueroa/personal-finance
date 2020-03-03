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
    before do
      get "/accounts/#{account.id}/statements/new"
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

  describe 'POST create' do
    context 'when parameters are valid' do
      let(:valid_params) { { statement: { balance: balance, date: date } } }
      before do
        post "/accounts/#{account.id}/statements", params: valid_params
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

      it 'updates @statement with new params' do
        expect(Statement.last.balance).to eq(new_balance)
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
