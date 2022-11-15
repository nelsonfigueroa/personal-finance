# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  authenticated :user do
    get '/dashboard', to: 'dashboard#index'
    get '/net_worth_graph', to: 'charts#net_worth_graph'
    get '/expenses_pie_chart', to: 'charts#expenses_pie_chart'
    get '/expenses_column_chart', to: 'charts#expenses_column_chart'

    resources :accounts do
      resources :statements, except: [:show]
    end

    resources :transactions, except: [:show]

    get 'transactions/download', to: 'transactions#download'
  end
end
