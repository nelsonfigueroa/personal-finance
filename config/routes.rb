# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  get '/about', to: 'home#about'
  # landing page demos
  get '/net_worth_demo', to: 'charts#net_worth_demo'
  get '/expenses_pie_chart_demo', to: 'charts#expenses_pie_chart_demo'
  get '/expenses_column_chart_demo', to: 'charts#expenses_column_chart_demo'

  devise_for :users

  authenticated :user do
    get '/net_worth_graph', to: 'charts#net_worth_graph'
    get '/expenses_pie_chart', to: 'charts#expenses_pie_chart'
    get '/expenses_column_chart', to: 'charts#expenses_column_chart'

    resources :accounts do
      resources :statements, only: %i[new create edit update]
    end

    resources :expense_trackers do
      resources :expenses, only: %i[new create edit update]
    end
  end
end
