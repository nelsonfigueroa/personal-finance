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

    # for chartkick
    # @net_worth_graph = @user.statements.sorted_by_date.pluck(:date, :balance)
    # @net_worth_graph = @user.statements.group_by_day(:date).maximum(:balance)

    # show net worth month to month
    @net_worth_graph = @user.statements.group_by_month(:date).sum(:balance)

    # pie chart of expenses for the month
    @expenses = @user.expenses.group(:category).sum(:amount)

  end
end
