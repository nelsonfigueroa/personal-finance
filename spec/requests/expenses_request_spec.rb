# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expenses', type: :request do
  let!(:user) { create(:user) }
  let(:expense_tracker) { create(:expense_tracker, user: user) }
  let(:expense) { create(:expense, expense_tracker: expense_tracker) }

  let(:amount) { Faker::Commerce.price(range: 0..100_000.0) }
  let(:date) { Faker::Date.in_date_period(year: 2018, month: 2) }

  before do
    sign_in user
  end

  describe 'GET new' do
    before do
      get "/expense_trackers/#{expense_tracker.id}/expenses/new"
    end

    it 'assigns @expense_tracker' do
      expect(assigns(:expense_tracker)).to eq(expense_tracker)
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns unsaved @expense' do
      expect(assigns(:expense)).to_not eq(nil)
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      let(:valid_params) { { expense: { amount: amount, date: date } } }
      before do
        post "/expense_trackers/#{expense_tracker.id}/expenses", params: valid_params
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'saves @expense' do
        expect(assigns(:expense)).to eq(Expense.last)
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
      end

      it 'redirects to expense_tracker_path of expense' do
        expect(response).to redirect_to(expense_tracker_path(expense_tracker))
      end

      it 'renders expense_trackers/show template' do
        follow_redirect!
        expect(response).to render_template('expense_trackers/show')
      end

      it 'includes "Expense created" in response body' do
        follow_redirect!
        expect(response.body).to include('Expense created')
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
      let(:invalid_params) { { expense: { amount: Faker::Alphanumeric.alpha(number: 5), date: date } } }
      before do
        post "/expense_trackers/#{expense_tracker.id}/expenses", params: invalid_params
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end

      it 'includes "Amount is not a number" in response body' do
        expect(response.body).to include('Amount is not a number')
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET edit' do
    context 'if expense exists' do
      before do
        get "/expense_trackers/#{expense_tracker.id}/expenses/#{expense.id}/edit"
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it 'assigns @expense' do
        expect(assigns(:expense)).to eq(expense)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if expense does not exist' do
      before do
        get "/expense_trackers/#{expense_tracker.id}/expenses/123456/edit"
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to expense_tracker_path' do
        expect(response).to redirect_to(expense_tracker_path(expense_tracker))
      end

      it 'renders expense_trackers/show template' do
        follow_redirect!
        expect(response).to render_template('expense_trackers/show')
      end

      it 'returns 302 before redirect' do
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
      let(:new_amount) { amount }
      let(:valid_params) { { expense: { amount: new_amount, date: date } } }
      before do
        put "/expense_trackers/#{expense_tracker.id}/expenses/#{expense.id}", params: valid_params
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'updates @expense with new params' do
        expect(Expense.last.amount).to eq(new_amount)
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
      end

      it 'redirects to expense_tracker_path' do
        expect(response).to redirect_to(expense_tracker_path(expense_tracker))
      end

      it 'renders expense_tracker/show template' do
        follow_redirect!
        expect(response).to render_template('expense_trackers/show')
      end
    end

    context 'when parameters are invalid' do
      let(:invalid_params) { { expense: { amount: Faker::String.random, date: date } } }
      before do
        put "/expense_trackers/#{expense_tracker.id}/expenses/#{expense.id}", params: invalid_params
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to edit_expense_tracker_expense_path' do
        expect(response).to redirect_to(edit_expense_tracker_expense_path(expense_tracker_id: expense_tracker.id, expense: expense))
      end

      it 'renders edit template' do
        follow_redirect!
        expect(response).to render_template(:edit)
      end

      it 'includes "Amount is not a number" in response body' do
        follow_redirect!
        expect(response.body).to include('Amount is not a number')
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
