# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :assign_user

  # net worth

  def net_worth_graph
    graph_data = generate_net_worth_data
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

    # then I can figure out how to add titles or labels to the pie chart on the site
    # and I also need to move over the pie chart to the appropriate section on the view

  def generate_yearly_income_chart_data
    year = Time.now.year
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    categories = transactions.where(category: %w[Savings Investing Income Dividends Interest]).pluck('category').uniq # maybe just hardcode this? will it be faster?
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
