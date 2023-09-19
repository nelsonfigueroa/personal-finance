# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :assign_user

  def index
    income_category = Category.where(user_id: @user, name: 'Income').first
    interest_category = Category.where(user_id: @user, name: 'Interest').first
    savings_category = Category.where(user_id: @user, name: 'Savings').first
    investing_category = Category.where(user_id: @user, name: 'Investing').first
    sale_category = Category.where(user_id: @user, name: 'Sale').first
    # @income_categories = [income_category, interest_category] # not needed?
    excluded_categories = [income_category, interest_category, savings_category, investing_category, sale_category]

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
    @yearly_dividends = @user.dividends.by_year(CURRENT_YEAR).sum(:amount_cents)

    ### transactions and spending ###
    yearly_income = income_category.transactions.by_year(CURRENT_YEAR).sum(:amount_cents) 
    yearly_interest = interest_category.transactions.by_year(CURRENT_YEAR).sum(:amount_cents)
    @total_yearly_income = ( yearly_income + yearly_interest + @yearly_dividends) / 100.0
    
    @yearly_interest = interest_category.transactions.by_year(CURRENT_YEAR).sum(:amount_cents) / 100.0
    @yearly_expenses = @transactions.by_year(CURRENT_YEAR).where.not(category: excluded_categories).sum(:amount_cents) / 100.0

    # adding decimal for display purposes in dashboard
    @yearly_dividends /= 100.0

    ### Income vs Expenses
    @income_vs_expenses_percentage = 'N/A'
    @income_vs_expenses_percentage = (@yearly_expenses / @total_yearly_income * 100).round unless (@total_yearly_income == 0.0) || (@yearly_expenses == 0.0)

    rent_category = @user.categories.where(name: 'Rent').first
    if rent_category.transactions.by_year(CURRENT_YEAR)
      yearly_rent = @transactions.by_year(CURRENT_YEAR).where(category: rent_category).sum(:amount_cents) / 100.0
      @rent_to_income_percentage = (yearly_rent / @total_yearly_income * 100).round
    end

    return if @transactions.empty?

    # for Yearly Expenses by Category
    @categories = @user.categories
    # don't include Savings, Investing, Income, Dividends, and Interest categories for expense tracking
    @categories -= excluded_categories

    @transactions_by_category_per_year = {}
    @transactions_by_category_per_year[CURRENT_YEAR] = {}

    @categories.each do |category|
      # sum of transactions by year, by category
      amount = category.transactions.by_year(CURRENT_YEAR).sum(:amount_cents) / 100.0
      next if amount <= 0.0

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
