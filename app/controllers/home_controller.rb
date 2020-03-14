# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def about; end

  def dashboard
    @user = current_user
  end
end
