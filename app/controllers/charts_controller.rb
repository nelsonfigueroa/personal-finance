# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :assign_user
  before_action :get_categories

  ### net worth graph ###

  def net_worth_graph
    graph_data = generate_net_worth_data
    render json: graph_data
  end

  ### single account graph ###

  def single_account_graph
    graph_data = generate_single_account_graph_data(params[:account_id])
    render json: graph_data
  end

  ### pie charts ###

  def yearly_income_vs_expenses_bar_chart
    year = session[:year]
    chart_data = generate_yearly_income_vs_expenses_chart_data(year)
    render json: chart_data
  end

  def yearly_income_vs_rent_bar_chart
    year = session[:year]
    chart_data = generate_yearly_income_vs_rent_chart_data(year)
    render json: chart_data
  end

  def yearly_expenses_pie_chart
    year = session[:year]
    chart_data = generate_yearly_expenses_chart_data(year)
    render json: chart_data
  end

  def yearly_income_pie_chart
    year = session[:year]
    chart_data = generate_yearly_income_chart_data(year)
    render json: chart_data
  end

  private

  def assign_user
    @user = current_user
  end

  def get_categories
    @income_category = Category.where(user_id: @user, name: 'Income').first
    @interest_category = Category.where(user_id: @user, name: 'Interest').first
    @savings_category = Category.where(user_id: @user, name: 'Savings').first
    @investing_category = Category.where(user_id: @user, name: 'Investing').first
    @sale_category = Category.where(user_id: @user, name: 'Sale').first
    @@income_categories = [@income_category, @interest_category]
    @@not_expense_categories = [@income_category, @interest_category, @savings_category, @investing_category, @sale_category]
  end

  def generate_yearly_income_vs_expenses_chart_data(year)
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    dividends = @user.dividends.by_year(year).sum(:amount_cents)
    income = (transactions.where(category: @@income_categories).sum(:amount_cents) + dividends) / 100.0
    expenses = transactions.where.not(category: @@not_expense_categories).sum(:amount_cents) / 100.0

    {
      Income: income,
      Expenses: expenses
    }
  end

  def generate_yearly_income_vs_rent_chart_data(year)
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    dividends = @user.dividends.by_year(year).sum(:amount_cents)
    income = (transactions.where(category: @@income_categories).sum(:amount_cents) + dividends) / 100.0
    rent_category = @user.categories.where(name: 'Rent').first
    rent = transactions.where(category: rent_category).sum(:amount_cents) / 100.0

    {
      Income: income,
      Rent: rent
    }
  end

  def generate_yearly_income_chart_data(year)
    transactions = @user.transactions.by_year(year)
    dividends = @user.dividends.by_year(year)

    return {} if transactions.empty?

    data = {}

    @@income_categories.each do |category|
      amount = transactions.where(category: category).sum(:amount_cents) / 100.0
      data.merge!(category.name => amount)
    end

    unless dividends.empty?
      dividends_total = dividends.sum(:amount_cents) / 100.0
      data['Dividends'] = dividends_total
    end

    data
  end

  def generate_yearly_expenses_chart_data(year)
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    categories = @user.categories - @@not_expense_categories
    data = {}

    categories.each do |category|
      amount = transactions.where(category: category).sum(:amount_cents) / 100.0
      data.merge!(category.name => amount)
    end

    data
  end

  def generate_single_account_graph_data(account_id)
    account = @user.accounts.find_by(id: account_id)
    return {} if account.nil?
    return {} if account.statements.empty?

    graph_data = {}

    account.statements.each do |statement|
      graph_data[statement.date] = statement.balance_cents / 100.0
    end

    graph_data
  end

  def generate_net_worth_data
    # hardcoding year
    statements = @user.statements.from_year(CURRENT_YEAR - 5)
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
    graph_data.sort
  end
end
