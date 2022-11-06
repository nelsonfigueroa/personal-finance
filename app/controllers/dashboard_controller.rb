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
    @transactions = @user.transactions
    @yearly_income = @transactions.by_year(Time.now.year).where(category: 'Income').sum(:amount_cents) / 100.0
    @yearly_saved = @transactions.by_year(Time.now.year).where(category: 'Savings').sum(:amount_cents) / 100.0
    @yearly_invested = @transactions.by_year(Time.now.year).where(category: 'Investing').sum(:amount_cents) / 100.0
    @yearly_expenses = @transactions.by_year(Time.now.year).where.not(category: %w[Savings Investing Income]).sum(:amount_cents) / 100.0

    unless @transactions.empty?
      # @transactions_by_category_per_month = {} # to do
      @transactions_by_category_per_year = {}

      years = @user.transactions.pluck('date').uniq.map(&:year).uniq
      # don't include Savings, Investing, and Income categories for expense tracking
      categories = @user.transactions.where.not(category: %w[Savings Investing Income]).pluck('category').uniq

      years.each do |year|
        @transactions_by_category_per_year[year] = {}
        categories.each do |category|
          # sum of transactions by year, by category
          amount = @user.transactions.by_year(year).where(category:).sum(:amount_cents) / 100.0
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
    end
  end

  def assign_user
    @user = current_user
  end
end
