# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :assign_user

  def index
    ### net worth ###
    @accounts = @user.accounts.includes([:statements]).sorted_by_name
    @net_worth = 0

    unless @user.statements.empty?
      # get the last statement for each account to determine net worth
      @accounts.each do |account|
        next if account.statements.empty?

        @net_worth += account.statements.sorted_by_date.last.balance_cents
      end
      @net_worth /= 100.0
    end

    # Initializing for calculations
    @transactions = @user.transactions

    ### Income vs Expenses
    @income_vs_expenses_percentage = 'N/A'
    income = @transactions.by_year(CURRENT_YEAR).where(category: @@income_categories).sum(:amount_cents) / 100.0
    expenses = @transactions.by_year(CURRENT_YEAR).where.not(category: @@not_expense_categories).sum(:amount_cents) / 100.0
    @income_vs_expenses_percentage = (expenses / income * 100).round unless (income == 0.0) || (expenses == 0.0)

    ### transactions and spending ###

    @yearly_income = @transactions.by_year(CURRENT_YEAR).where(category: 'Income').sum(:amount_cents) / 100.0
    @yearly_saved = @transactions.by_year(CURRENT_YEAR).where(category: 'Savings').sum(:amount_cents) / 100.0
    @yearly_invested = @transactions.by_year(CURRENT_YEAR).where(category: 'Investing').sum(:amount_cents) / 100.0
    @yearly_dividends = @user.dividends.by_year(CURRENT_YEAR).sum(:amount_cents) / 100.0
    @yearly_interest = @transactions.by_year(CURRENT_YEAR).where(category: 'Interest').sum(:amount_cents) / 100.0
    @yearly_expenses = @transactions.by_year(CURRENT_YEAR).where.not(category: @@not_expense_categories).sum(:amount_cents) / 100.0

    if @transactions.by_year(CURRENT_YEAR).pluck(:category).uniq.include? 'Rent'
      yearly_rent = @transactions.by_year(CURRENT_YEAR).where(category: 'Rent').sum(:amount_cents) / 100.0
      @rent_to_income_percentage = (yearly_rent / @yearly_income * 100).round
    end

    return if @transactions.empty?

    # for Yearly Expenses by Category
    @transactions_by_category_per_year = {}

    # don't include Savings, Investing, Income, Dividends, and Interest categories for expense tracking
    categories = @transactions.by_year(CURRENT_YEAR).where.not(category: @@not_expense_categories).pluck('category').uniq

    @transactions_by_category_per_year[CURRENT_YEAR] = {}
    categories.each do |category|
      # sum of transactions by year, by category
      amount = @transactions.by_year(CURRENT_YEAR).where(category: category).sum(:amount_cents) / 100.0
      @transactions_by_category_per_year[CURRENT_YEAR].merge!(category => amount)
    end

    # sort hash for each year by values, descending
    @transactions_by_category_per_year[CURRENT_YEAR] = @transactions_by_category_per_year[CURRENT_YEAR].sort_by { |_k, v| -v }.to_h

    # structure of @transactions_by_category_per_year
    # {
    #   "year": {
    #     "category": "amount"
    #   }
    # }
    #
    # example:
    # {
    #   "2022": {
    #     "entertainment": "500.12"
    #   }
    # }
  end

  private

  def assign_user
    @user = current_user
  end
end
