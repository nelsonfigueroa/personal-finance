# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :assign_user

  def index
    @accounts = @user.accounts
  end

  def assign_user
    @user = current_user
  end
end
