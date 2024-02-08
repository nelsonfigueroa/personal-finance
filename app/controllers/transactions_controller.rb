# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :assign_user

  def index
    @income_category = Category.where(user_id: @user, name: 'Income').first
    @interest_category = Category.where(user_id: @user, name: 'Interest').first
    @savings_category = Category.where(user_id: @user, name: 'Savings').first
    @investing_category = Category.where(user_id: @user, name: 'Investing').first
    @sale_category = Category.where(user_id: @user, name: 'Sale').first
    @income_categories = [@income_category, @interest_category]
    @excluded_categories = [@income_category, @interest_category, @savings_category, @investing_category, @sale_category]

    # gathering all years needed for dropdown filter
    @years_for_switcher = @user.transactions.pluck(:date).map(&:year)
    @years_for_switcher << CURRENT_YEAR
    @years_for_switcher.uniq!.sort!.reverse!

    # year switcher for transactions
    year = if params[:year].present?
             params[:year].to_i
           else
             CURRENT_YEAR
           end

    # year to display on dropdown menu
    @selected_year = year

    @transactions = @user.transactions.by_year(year).includes([:category]).sorted_by_date.group_by { |transaction| transaction.date.beginning_of_month }

    @monthly_expenses = {}
    @monthly_income = {}

    @transactions.each_key do |month|
      start_date = month.beginning_of_month
      end_date = month.end_of_month
      @monthly_expenses[month] = @user.transactions.where.not(category: @excluded_categories).where(date: start_date..end_date).sum(:amount_cents) / 100.0
      @monthly_income[month] = @user.transactions.where(category: @income_categories).where(date: start_date..end_date).sum(:amount_cents) / 100.0
    end
  end

  def show
    @transaction = @user.transactions.find_by(id: params[:id])

    return unless @transaction.nil?

    redirect_to transactions_path, alert: 'Invalid ID'
  end

  def new
    @transaction = Transaction.new
  end

  def edit
    @transaction = @user.transactions.find_by(id: params[:id])

    return unless @transaction.nil?

    redirect_to transactions_path, alert: 'Invalid ID'
  end

  def create
    category_name = transaction_params[:category]
    category = @user.categories.where(name: category_name).first

    if category.nil?
      flash[:alert] = 'Category does not exist. Go create it first!'
      redirect_to(transactions_path)
      return
    end

    params = transaction_params
    params[:category] = category

    @transaction = Transaction.new(params)
    @transaction.user_id = @user.id

    if @transaction.save
      flash[:notice] = 'Transaction created'
      redirect_to(transactions_path)
    else
      flash[:alert] = @transaction.errors.full_messages.join(', ')
      render('new')
    end
  end

  def update
    @transaction = @user.transactions.find_by(id: params[:id])

    category_name = transaction_params[:category]
    category = @user.categories.where(name: category_name).first

    if category.nil?
      flash[:alert] = 'Category does not exist. Go create it first!'
      redirect_to(transactions_path)
      return
    end

    params = transaction_params
    params[:category] = category

    if @transaction.update(params)
      flash[:notice] = 'Transaction updated'
      redirect_back_or_to @transaction
    else
      flash[:alert] = @transaction.errors.full_messages.join(', ')
      redirect_to(edit_transaction_path(@transaction))
    end
  end

  def destroy
    @transaction = @user.transactions.find_by(id: params[:id])

    if @transaction.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(transactions_path) && return
    end

    if @transaction.destroy
      flash[:notice] = 'Transaction Deleted'
    else
      flash[:alert] = @transaction.errors.full_messages.join(', ')
    end
    redirect_to(transactions_path)
  end

  def download
    render json: @user.transactions.to_json
  end

  private

  def transaction_params
    params.require(:transaction).permit(:category, :amount, :date, :notes, :merchant)
  end

  def assign_user
    @user = current_user
  end
end
