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

    ### transactions and spending ###

    # TODO would this be faster if I looped through everything instead of making database queries?
    @transactions = @user.transactions
    @yearly_income = @transactions.by_year(Time.zone.now.year).where(category: 'Income').sum(:amount_cents) / 100.0
    @yearly_saved = @transactions.by_year(Time.zone.now.year).where(category: 'Savings').sum(:amount_cents) / 100.0
    @yearly_invested = @transactions.by_year(Time.zone.now.year).where(category: 'Investing').sum(:amount_cents) / 100.0
    @yearly_dividends = @transactions.by_year(Time.zone.now.year).where(category: 'Dividends').sum(:amount_cents) / 100.0
    @yearly_interest = @transactions.by_year(Time.zone.now.year).where(category: 'Interest').sum(:amount_cents) / 100.0
    @yearly_expenses = @transactions.by_year(Time.zone.now.year).where.not(category: %w[Savings Investing Income Dividends Interest]).sum(:amount_cents) / 100.0

    if @transactions.by_year(Time.zone.now.year).pluck(:category).uniq.include? 'Rent'
      yearly_rent = @transactions.by_year(Time.zone.now.year).where(category: 'Rent').sum(:amount_cents) / 100.0
      @rent_to_income_percentage = (yearly_rent / @yearly_income * 100).round
    end

    return if @transactions.empty?

    # for Yearly Expenses by Category
    @transactions_by_category_per_year = {}

    years = @transactions.pluck('date').uniq.map(&:year).uniq
    # don't include Savings, Investing, Income, Dividends, and Interest categories for expense tracking
    categories = @transactions.where.not(category: %w[Savings Investing Income Dividends Interest]).pluck('category').uniq

    years.each do |year|
      @transactions_by_category_per_year[year] = {}
      categories.each do |category|
        # sum of transactions by year, by category
        amount = @transactions.by_year(year).where(category: category).sum(:amount_cents) / 100.0
        @transactions_by_category_per_year[year].merge!(category => amount)
      end

      # sort hash for each year by values, descending
      @transactions_by_category_per_year[year] = @transactions_by_category_per_year[year].sort_by { |_k, v| -v }.to_h
    end

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
