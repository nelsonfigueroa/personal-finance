# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      redirect_to('/dashboard')
    else
      redirect_to('/users/sign_in')
    end
  end
end
