# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :assign_user, only: %i[dashboard]

  def index; end

  def about; end

  def dashboard
    # sum of statements from current month - debt (tbd)
    @net_worth = @user.statements.where(date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:balance)
    # statements this month - sum of statements from last month
    @net_worth_change = @net_worth - @user.statements.where(date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).sum(:balance)
    # total expenses for current month
    @expenses_this_month = @user.expenses.where(date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount)
  end

  private

  def assign_user
    @user = current_user
  end
end
