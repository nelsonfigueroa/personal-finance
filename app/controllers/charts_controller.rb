# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :assign_user, only: %i[net_worth_graph expenses_pie_chart expenses_column_chart]

  # net worth

  def net_worth_graph
    graph_data = generate_net_worth_data
    graph_data = [] if graph_data.nil?
    render json: graph_data
  end

  # demos for future reference 

  # def expenses_pie_chart_demo
  #   render json: { 'Clothing' => 0.20454e3, 'Restaurants' => 0.9888e2, 'Entertainment' => 0.5977e2, 'Groceries' => 0.14943e3 }
  # end

  # def expenses_column_chart_demo
  #   render json: { 'Jan 2019' => 0.484132e4, 'Feb 2019' => 0.422839e4, 'Mar 2019' => 0.320202e4, 'Apr 2019' => 0.415266e4, 'May 2019' => 0.400948e4 }
  # end

  # expense tracking

  # def expenses_pie_chart
  #   render json: @user.expenses.where(date: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month).group(:category).sum(:amount)
  # end

  # def expenses_column_chart
  #   render json: @user.expenses.group_by_month(:date).sum(:amount)
  # end

  private

  def assign_user
    @user = current_user
  end

  def generate_net_worth_data
    accounts = @user.accounts
    statements = @user.statements
    return nil if statements.empty?

    graph_data = {}

    dates = statements.pluck(:date)

    # there has to be a better way of doing this...but it works.

    dates.each do |date|
      sum = 0
      accounts.each do |account|
        statement = statements.where(account_id: account.id).where('date <= ?', date).order(date: :desc).limit(1)[0]
        next if statement.nil?
        sum += statement.balance_cents
      end

      sum /= 100.0
      next if sum == 0.0

      # add that to json hash that gets returned
      graph_data[date] = sum
    end
    graph_data
  end
end
