# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def about; end

  def dashboard
    @user = current_user
    @net_worth = @user.statements.sum(:balance)

    # for chartkick
    # @net_worth_graph = @user.statements.sorted_by_date.pluck(:date, :balance)
    # @net_worth_graph = @user.statements.group_by_day(:date).maximum(:balance)

    # show net worth month to month
    @net_worth_graph = @user.statements.group_by_month(:date).sum(:balance)
  end
end
