# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :assign_user

  # net worth

  def net_worth_graph
    graph_data = generate_net_worth_data
    render json: graph_data
  end

  # single account graph

  def single_account_graph(account_id)
    graph_data = generate_single_account_graph_data(account_id)
    render json: graph_data
  end

  # pie charts

  def yearly_expenses_pie_chart
    chart_data = generate_yearly_expenses_chart_data
    render json: chart_data
  end

  def yearly_income_pie_chart
    chart_data = generate_yearly_income_chart_data
    render json: chart_data
  end

  private

  def assign_user
    @user = current_user
  end

  def generate_yearly_income_chart_data
    year = Time.now.year
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    # Not including Savings or Investing since those are generally a transfer of money rather than new money coming in
    # May need "Gains" category for capital gains when stock is sold
    categories = %w[Income Dividends Interest]
    data = {}

    categories.each do |category|
      amount = transactions.where(category: category).sum(:amount_cents) / 100.0
      data.merge!(category => amount)
    end

    data
  end

  def generate_yearly_expenses_chart_data
    year = Time.now.year
    transactions = @user.transactions.by_year(Time.zone.now.year) # change this to year

    return {} if transactions.empty?

    categories = transactions.where.not(category: %w[Savings Investing Income Dividends Interest]).pluck('category').uniq
    data = {}

    categories.each do |category|
      amount = transactions.where(category: category).sum(:amount_cents) / 100.0
      data.merge!(category => amount)
    end
  
    data
  end

  def generate_single_account_graph_data(account_id)
    account = @user.accounts.find_by_id(account_id)
    return {} if account.empty?
    return {} if account.statements.empty?


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
