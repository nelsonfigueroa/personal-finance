# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :assign_user

  def index
    income_category = Category.where(user_id: @user, name: 'Income').first
    interest_category = Category.where(user_id: @user, name: 'Interest').first
    excluded_categories = [income_category, interest_category]

    # gathering all years needed for dropdown filter
    @years_for_switcher = @user.transactions.pluck(:date).map(&:year)
    @years_for_switcher << CURRENT_YEAR
    @years_for_switcher.uniq!.sort!.reverse! unless @years_for_switcher.count == 1

    # year switcher for transactions
    if params[:year].present?
      year = params[:year].to_i
      session[:year] = params[:year].to_i # session param gets passed to chart actions automatically
    else
      year = CURRENT_YEAR
      session[:year] = CURRENT_YEAR # session param gets passed to chart actions automatically
    end

    # year to display on dropdown menu
    @selected_year = year

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

    ### transactions and spending ###
    yearly_income = if income_category.nil?
                      0
                    else
                      income_category.transactions.by_year(year).sum(:amount_cents)
                    end
    yearly_interest = if interest_category.nil?
                        0
                      else
                        interest_category.transactions.by_year(year).sum(:amount_cents)
                      end

    @total_yearly_income = (yearly_income + yearly_interest) / 100.0

    @yearly_interest = yearly_interest / 100.0
    @yearly_expenses = @transactions.by_year(year).where.not(category: excluded_categories).sum(:amount_cents) / 100.0

    ### Income vs Expenses
    @income_vs_expenses_percentage = 'N/A'
    @income_vs_expenses_percentage = (@yearly_expenses / @total_yearly_income * 100).round unless (@total_yearly_income == 0.0) || (@yearly_expenses == 0.0)

    rent_category = @user.categories.where(name: 'Rent').first
    unless rent_category.nil? || rent_category.transactions.by_year(year).empty?
      yearly_rent = @transactions.by_year(year).where(category: rent_category).sum(:amount_cents) / 100.0
      @rent_to_income_percentage = (yearly_rent / @total_yearly_income * 100).round
    end

    return if @transactions.empty?

    # for Yearly Expenses by Category
    @categories = @user.categories
    @categories -= excluded_categories

    @transactions_by_category_per_year = {}
    @transactions_by_category_per_year[year] = {}

    @categories.each do |category|
      # sum of transactions by year, by category
      amount = category.transactions.by_year(year).sum(:amount_cents) / 100.0
      next if amount <= 0.0

      @transactions_by_category_per_year[year].merge!(category => amount)
    end

    # sort hash for each year by values, descending
    @transactions_by_category_per_year[year] = @transactions_by_category_per_year[year].sort_by { |_k, v| -v }.to_h

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
