# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  authenticated :user do
    get '/dashboard', to: 'dashboard#index'
    get '/net_worth_graph', to: 'charts#net_worth_graph'
    get '/single_account_graph', to: 'charts#single_account_graph'

    get '/yearly_income_vs_expenses_bar_chart', to: 'charts#yearly_income_vs_expenses_bar_chart'
    get '/yearly_income_vs_rent_bar_chart', to: 'charts#yearly_income_vs_rent_bar_chart'
    get '/yearly_expenses_pie_chart', to: 'charts#yearly_expenses_pie_chart'
    get '/yearly_income_pie_chart', to: 'charts#yearly_income_pie_chart'

    resources :accounts do
      resources :statements, except: [:show]
    end

    resources :dividends
    resources :transactions, except: [:show]
    resources :categories

    get 'transactions/download', to: 'transactions#download'
    post 'transactions/import', to: 'transactions#import'
    get 'statements/download', to: 'statements#download'
  end
end
