# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Statement Requests', type: :request do
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

  describe 'GET new' do
    it 'renders new template' do
      get "/accounts/#{account.id}/statements/new"
      expect(response).to render_template(:new)
      expect(assigns(:statement)).to_not eq(nil)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST create' do
    let(:valid_params) { { statement: { balance: 200.34, date: '1/1/2020' } } }
    let(:invalid_params) { { statement: { balance: 'abc', date: '1/1/2020' } } }
    
    it 'redirects to account_path if statement is created' do
      post "/accounts/#{account.id}/statements", params: valid_params
      expect(response).to redirect_to(account_path(account))
      follow_redirect!
      expect(response).to render_template(:show) # this might not work, might need to specify controller?
      expect(response.body).to include('Statement created')
      expect(response).to have_http_status(:ok)
    end

    it 'renders new template if statement is not created' do
      post "/accounts/#{account.id}/statements", params: invalid_params
      expect(response).to render_template(:new)
      expect(response.body).to include('Balance is not a number')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET edit' do
    it 'renders edit template if statement exists' do
      get "/accounts/#{account.id}/statements/#{statement.id}/edit"
      expect(response).to render_template(:edit)
      expect(assigns(:statement)).to eq(statement)
      expect(response).to have_http_status(:ok)
    end

    it 'redirects and renders account show template if statement does not exist' do
      get "/accounts/#{account.id}/statements/123456/edit"
      expect(response).to redirect_to(account_path(account))
      follow_redirect!
      expect(response).to render_template(:show) # this might not work again
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT update' do
    let(:valid_params) { { statement: { balance: 200.34, date: '1/1/2020' } } }
    let(:invalid_params) { { statement: { balance: 'abc', date: '1/1/2020' } } }

    context 'when parameters are valid' do
      xit 'updates statement with new params and renders account show template' do

      end
    end

    context 'when parameters are invalid' do
      xit 'redirects to edit_statement_path and renders edit template' do

      end
    end
  end
end































