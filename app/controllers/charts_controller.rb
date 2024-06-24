# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :assign_user
  before_action :assign_categories

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

  def assign_categories
    @income_category = Category.where(user_id: @user, name: 'Income').first
    @interest_category = Category.where(user_id: @user, name: 'Interest').first
    @savings_category = Category.where(user_id: @user, name: 'Savings').first
    @@income_categories = [@income_category, @interest_category]
    @@not_expense_categories = [@income_category, @interest_category, @savings_category]
  end

  def generate_yearly_income_vs_expenses_chart_data(year)
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    income = transactions.where(category: @@income_categories).sum(:amount_cents) / 100.0
    expenses = transactions.where.not(category: @@not_expense_categories).sum(:amount_cents) / 100.0

    {
      Income: income,
      Expenses: expenses
    }
  end

  def generate_yearly_income_vs_rent_chart_data(year)
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    income = transactions.where(category: @@income_categories).sum(:amount_cents) / 100.0
    rent_category = @user.categories.where(name: 'Rent').first
    rent = transactions.where(category: rent_category).sum(:amount_cents) / 100.0

    {
      Income: income,
      Rent: rent
    }
  end

  def generate_yearly_income_chart_data(year)
    transactions = @user.transactions.by_year(year)

    return {} if transactions.empty?

    data = {}

    @@income_categories.each do |category|
      amount = transactions.where(category: category).sum(:amount_cents) / 100.0
      data.merge!(category.name => amount)
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
    account_ids = @user.accounts.pluck(:id)

    # hardcoding 5 years back of statements
    statements = @user.statements.from_year(CURRENT_YEAR - 5)
    dates = statements.pluck(:date).uniq

    # Preload statements for all accounts up to the latest date in dates array
    all_statements = statements.where(account_id: account_ids).where('date <= ?', dates.max).order(account_id: :asc, date: :desc)
    return {} if all_statements.empty?

    # Group statements by account_id for easy lookup
    statements_by_account = all_statements.group_by(&:account_id)

    graph_data = {}

    dates.each do |date|
      sum = 0

      account_ids.each do |account_id|
        # Get the latest statement for the account up to the given date
        statement = statements_by_account[account_id]&.find { |s| s.date <= date }
        next if statement.nil?
        sum += statement.balance_cents
      end

      sum /= 100.0

      graph_data[date] = sum
    end

    graph_data.sort
  end
end
