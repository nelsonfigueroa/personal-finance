# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :assign_user, only: %i[dashboard]

  def index
    @net_worth_data = {"Tue, 01 Jan 2019"=>0.1586734e5, "Fri, 01 Feb 2019"=>0.2191908e5, "Fri, 01 Mar 2019"=>0.3425831e5, "Mon, 01 Apr 2019"=>0.4266992e5, "Wed, 01 May 2019"=>0.574668e5, "Sat, 01 Jun 2019"=>0.6265551e5, "Mon, 01 Jul 2019"=>0.7254844e5, "Thu, 01 Aug 2019"=>0.8838481e5, "Sun, 01 Sep 2019"=>0.9252975e5, "Tue, 01 Oct 2019"=>0.1000581e6, "Fri, 01 Nov 2019"=>0.11697328e6, "Sun, 01 Dec 2019"=>0.12130413e6}
    @column_chart_data = {"Jan 2019"=>0.484132e4, "Feb 2019"=>0.422839e4, "Mar 2019"=>0.320202e4, "Apr 2019"=>0.415266e4, "May 2019"=>0.400948e4}
    @pie_chart_data = {"Clothing"=>0.20454e3, "Restaurants"=>0.9888e2, "Entertainment"=>0.5977e2, "Groceries"=>0.14943e3}
  end

  def about; end

  def dashboard
    # sum of statements from current month
    @net_worth = @user.statements.where(date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:balance)
    # statements this month - sum of statements from last month
    @net_worth_change = @net_worth - @user.statements.where(date: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).sum(:balance)
    # show net worth month to month
    @net_worth_graph = @user.statements.group_by_month(:date).sum(:balance)

    # total expenses for current month
    @expenses_this_month = @user.expenses.where(date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount)
    # expenses by category this month
    @expenses_by_category = @user.expenses.where(date: Date.current.beginning_of_month..Date.current.end_of_month).group(:category).sum(:amount)
    # expenses month to month
    @expenses_month_to_month = @user.expenses.group_by_month(:date).sum(:amount)
  end

  private

  def assign_user
    @user = current_user
  end
end
