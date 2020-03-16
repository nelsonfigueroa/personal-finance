# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def about; end

  def dashboard
    @user = current_user

    # sum of statements from current month
    @net_worth = @user.statements.where(date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:balance) 
    # statements this month - sum of statements from last month
    @net_worth_change = @net_worth - @user.statements.where(date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).sum(:balance)
    # show net worth month to month
    @net_worth_graph = @user.statements.group_by_month(:date).sum(:balance)

    # total expenses for current month
    @expenses_this_month = @user.expenses.where(date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount) 
    # expenses by category this month
    @expenses_by_category = @user.expenses.where(date: Date.current.beginning_of_month..Date.current.end_of_month).group(:category).sum(:amount)
    # expenses month to month
    @expenses_month_to_month = @user.expenses.group_by_month(:date).sum(:amount)

  end
end
