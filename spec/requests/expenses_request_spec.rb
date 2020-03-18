# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expenses', type: :request do # rubocop:disable Metrics/BlockLength
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
end
