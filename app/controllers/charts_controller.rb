# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :assign_user

  # net worth

  def net_worth_graph
    graph_data = generate_net_worth_data
    render json: graph_data
  end

  # pie chart

  def yearly_expenses_pie_chart
    data = {
      "Rent": 2002,
      "Groceries": 198.2
    }
    render json: data
  end

  private

  def assign_user
    @user = current_user
  end

  def generate_net_worth_data
    statements = @user.statements
    return [] if statements.empty?

    graph_data = {}

    account_ids = @user.accounts.pluck(:id)
    dates = statements.pluck(:date).uniq

    dates.each do |date|
      sum = 0
      account_ids.each do |account_id|
        statement = statements.where(account_id: account_id).where('date <= ?', date).order(date: :desc).limit(1)[0]
        next if statement.nil?

        sum += statement.balance_cents
      end

      sum /= 100.0

      graph_data[date] = sum
    end
    graph_data
  end
end
