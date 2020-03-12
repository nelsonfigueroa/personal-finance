# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ExpenseTrackers', type: :request do
  let!(:user) { create(:user) }
  let(:expense_tracker) { create(:expense_tracker, user: user) }

  before do
    sign_in user
  end

  describe 'GET index' do
    before do 
      get '/expense_trackers'
    end

    it 'renders index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns @expense_trackers' do
      expect(assigns(:expense_trackers)).to eq(user.expense_trackers)
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET show' do
    context 'if expense tracker exists' do
      before do
        get "/expense_trackers/#{expense_tracker.id}"
      end

      it 'renders show template' do
        expect(response).to render_template(:show)
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if expense tracker does not exist' do
      before do
        get '/expense_trackers/123456'
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to expense_trackers_path' do
        expect(response).to redirect_to(expense_trackers_path)
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
      get '/expense_trackers/new'
    end

    it 'renders new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns unsaved @expense_tracker' do
      expect(assigns(:expense_tracker)).to_not eq(nil)
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    context 'when parameters are valid' do
      let(:valid_params) { { expense_tracker: { category: Faker::Alphanumeric.alpha(number: 40) } } }
      before do
        post '/expense_trackers', params: valid_params
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
      end

      it 'redirects to expense_trackers_path' do
        expect(response).to redirect_to(expense_trackers_path)
      end

      it 'renders index template' do
        follow_redirect!
        expect(response).to render_template(:index)
      end

      it 'includes "Expense Tracker created" in response body' do
        follow_redirect!
        expect(response.body).to include('Expense Tracker created')
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
      let(:invalid_params) { { expense_tracker: { category: Faker::Number.number(digits: 3) } } }
      before do
        post '/expense_trackers', params: invalid_params
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end

      it 'includes "Category is invalid" in response body' do
        expect(response.body).to include('Category is invalid')
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET edit' do
    context 'if expense_tracker exists' do
      before do
        get "/expense_trackers/#{expense_tracker.id}/edit"
      end

      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end

      it 'assigns @expense_tracker' do
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if expense_tracker does not exist' do
      before do
        get '/expense_trackers/123456/edit'
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to expense_trackers_path' do
        expect(response).to redirect_to(expense_trackers_path)
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
      let(:new_category) { Faker::Commerce.department(max: 1) }
      let(:valid_params) { { expense_tracker: { category: new_category } } }
      before do
        put "/expense_trackers/#{expense_tracker.id}", params: valid_params
      end

      it 'updates @expense_tracker with new params' do
        expect(ExpenseTracker.last.category).to eq(new_category)
      end

      it 'assigns flash[:notice]' do
        expect(flash[:notice]).to_not be(nil)
      end

      it 'redirects to expense_tracker_path' do
        expect(response).to redirect_to(expense_tracker_path(expense_tracker))
      end

      it 'renders show template' do
        follow_redirect!
        expect(response).to render_template(:show)
      end

      it 'assigns @expense_tracker in show template' do
        follow_redirect!
        expect(assigns(:expense_tracker)).to eq(expense_tracker)
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
      let(:invalid_params) { { expense_tracker: { category: 123 } } }
      before do
        put "/expense_trackers/#{expense_tracker.id}", params: invalid_params
      end

      it 'assigns flash[:alert]' do
        expect(flash[:alert]).to_not be(nil)
      end

      it 'redirects to edit_expense_tracker_path' do
        expect(response).to redirect_to(edit_expense_tracker_path(expense_tracker))
      end

      it 'renders edit template' do
        follow_redirect!
        expect(response).to render_template(:edit)
      end

      it 'includes "category is invalid" in response body' do
        follow_redirect!
        expect(response.body).to include('Category is invalid')
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
