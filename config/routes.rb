# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  get '/faq', to: 'home#faq'

  devise_for :users

  authenticated :user do
    resources :accounts
  end
end
