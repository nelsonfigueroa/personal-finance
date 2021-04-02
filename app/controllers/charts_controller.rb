# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :assign_user, only: %i[net_worth_graph expenses_pie_chart expenses_column_chart]

  # landing page demos
  # no longer used, keeping them commented out for reference

  # def net_worth_demo
  #   render json: { 'Tue, 01 Jan 2019' => 0.1586734e5, 'Fri, 01 Feb 2019' => 0.2191908e5, 'Fri, 01 Mar 2019' => 0.3425831e5, 'Mon, 01 Apr 2019' => 0.4266992e5, 'Wed, 01 May 2019' => 0.574668e5, 'Sat, 01 Jun 2019' => 0.6265551e5, 'Mon, 01 Jul 2019' => 0.7254844e5, 'Thu, 01 Aug 2019' => 0.8838481e5, 'Sun, 01 Sep 2019' => 0.9252975e5, 'Tue, 01 Oct 2019' => 0.1000581e6, 'Fri, 01 Nov 2019' => 0.11697328e6, 'Sun, 01 Dec 2019' => 0.12130413e6 }
  # end

  # def expenses_pie_chart_demo
  #   render json: { 'Clothing' => 0.20454e3, 'Restaurants' => 0.9888e2, 'Entertainment' => 0.5977e2, 'Groceries' => 0.14943e3 }
  # end

  # def expenses_column_chart_demo
  #   render json: { 'Jan 2019' => 0.484132e4, 'Feb 2019' => 0.422839e4, 'Mar 2019' => 0.320202e4, 'Apr 2019' => 0.415266e4, 'May 2019' => 0.400948e4 }
  # end

  # net worth

  def net_worth_graph
    json = {} # the json that gets returned
    accounts = @user.accounts
    statements = @user.statements.sorted_by_date.includes([:account])
    earliest_date = statements.first.date
    latest_date = statements.last.date

    # generate the hash
    account_ending_amounts = {}
    accounts.each do |account|
      account_ending_amounts[account.name] = 0
    end

    # loop through each date
    (earliest_date..latest_date).each do |date|
      # check statements to see what statements show up for that date
      statements_in_current_date = statements.where(date: date)

      next if statements_in_current_date.empty?

      statements_in_current_date.each do |statement|
        # update ending amounts hash for each statement that shows up in this date
        # accounts that don't show up will keep the previous value
        account_ending_amounts[statement.account.name] = statement.balance_cents / 100
      end

      # sum the values of all accounts and their values in the hash with the current date
      sum = 0
      account_ending_amounts.each do |_, value|
        sum += value
      end

      # add that to json hash that gets returned
      json[date] = sum

      # repeat
    end

    render json: json
  end

  # expense tracking

  # def expenses_pie_chart
  #   render json: @user.expenses.where(date: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month).group(:category).sum(:amount)
  # end

  # def expenses_column_chart
  #   render json: @user.expenses.group_by_month(:date).sum(:amount)
  # end

  private

  def assign_user
    @user = current_user
  end
end
