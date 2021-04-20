# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :assign_user

  def index
    @accounts = @user.accounts.includes([:statements]).sorted_by_name
    @net_worth = 0

    unless @user.statements.empty?
      # get the last statement for each account to determine net worth
      @accounts.each do |account|
        next if account.statements.empty?
        @net_worth += account.statements.sorted_by_date.last.balance_cents
      end
      @net_worth /= 100.0
    end
  end

  def assign_user
    @user = current_user
  end
end
