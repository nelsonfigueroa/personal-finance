# frozen_string_literal: true
require 'csv'

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
    @years_for_switcher.uniq!.sort!.reverse! unless @years_for_switcher.count == 1

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

  def import
      if params[:import_from] == "Apple Card"
          apple_card_csv_importer(params[:csv])
      elsif params[:import_from] == "Copilot Money"
          copilot_money_csv_importer(params[:csv])
      end

      redirect_to(transactions_path)
  end

  private

  def transaction_params
    params.require(:transaction).permit(:category, :amount, :date, :notes, :merchant)
  end

  def assign_user
    @user = current_user
  end

  def apple_card_csv_importer(csv)
      CSV.parse(csv.read) do |row|
          # skip the first row of headers
          if row[0] == "Transaction Date"
              next
          end

          # converting to proper format
          date = Date.strptime(row[0], "%m/%d/%Y")
          date = parsed_date.strftime("%Y-%m-%d")

          merchant = row[3]
          category_name = row[4]
          type = row[5]
          amount = row[6]

          if type == "Payment"
            # this is a payment from another account, nothing to do here
              next
          elsif type == "Purchase"
              # check that the category actually exists, otherwise create it and assign to  the transaction
            category = Category.where(user_id: @user.id, name: category_name).first
            if category.nil?
                category = Category.create!(user_id: @user.id, name: category_name, color: "#FFF")
            end

            amount_cents = (amount.to_f * 100).round.abs
            Transaction.create!(user_id: @user.id, category_id: category.id, date: date, merchant: merchant, notes: nil, amount_cents: amount_cents, amount_currency: 'USD')
          end
      end
  end

  def copilot_money_csv_importer(csv)
      CSV.parse(csv.read) do |row|
          # skip the first row of headers
          if row[0] == "date"
              next
          end

          date = row[0]
          merchant = row[1].force_encoding('UTF-8') unless row[1].nil?
          amount = row[2]
          category_name = row[4]
          excluded = row[6].downcase
          transaction_type = row[7]
          notes = row[10].force_encoding('UTF-8') unless row[10].nil?

          # don't care about internal transfers
          if transaction_type == "internal transfer"
              next
          elsif transaction_type == "income"
          # the category in the CSV will be empty for income transactions so we can hardcode the category name
              category = Category.where(user_id: @user.id, name: "Income").first
              if category.nil?
                  category = Category.create!(user_id: @user.id, name: "Income", color: "#FFF")
              end
              # don't care about excluded transactions that do not fall under "income"
          elsif excluded == "true"
              next
          elsif transaction_type == "regular" && excluded == "false"
              category = Category.where(user_id: @user.id, name: category_name).first
              if category.nil?
                  category = Category.create!(user_id: @user.id, name: category_name, color: "#FFF")
              end
          end

          amount_cents = (amount.to_f * 100).round.abs

          Transaction.create!(user_id: @user.id, category_id: category.id, date: date, merchant: merchant, notes: notes, amount_cents: amount_cents, amount_currency: 'USD')
      end
  end
end
