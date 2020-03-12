# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  get '/faq', to: 'home#faq'

  devise_for :users

  authenticated :user do
    get '/dashboard', to: 'home#dashboard'
    
    resources :accounts do
      resources :statements, only: %i[new create edit update]
    end

    resources :expense_trackers
  end
end
