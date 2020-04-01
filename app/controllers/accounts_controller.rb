# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :assign_user

  def index
    @accounts = @user.accounts.order(:name)

    # sum of statements from each account for current month. Maybe this should be for previous month? Becase ending balances might be input at end of month
    @net_worth = @user.statements.where(date: Date.today.beginning_of_month..Date.today.end_of_month).sum(:balance)

    # statements this month - sum of statements from last month
    @net_worth_change = @net_worth - @user.statements.where(date: Date.today.prev_month.beginning_of_month..Date.today.prev_month.end_of_month).sum(:balance)
  end

  def show
    @account = @user.accounts.find_by(id: params[:id])

    if @account.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(accounts_path)
    else
      @statements = @account.statements
    end
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    # keep here for security, hidden fields can easily be modified.
    @account.user_id = @user.id

    if @account.save
      flash[:notice] = 'Account created'
      redirect_to(accounts_path)
    else
      flash[:alert] = @account.errors.full_messages.join(', ')
      render('new')
    end
  end

  def edit
    @account = @user.accounts.find_by(id: params[:id])

    if @account.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(accounts_path)
    end
  end

  def update
    @account = @user.accounts.find_by(id: params[:id])
    if @account.update(account_params)
      flash[:notice] = 'Account updated'
      redirect_to(@account)
    else
      flash[:alert] = @account.errors.full_messages.join(', ')
      redirect_to(edit_account_path(@account))
    end
  end

  def destroy
    @account = @user.accounts.find_by(id: params[:id])

    if @account.destroy
      flash[:notice] = 'Account Deleted'
    else
      flash[:alert] = @account.errors.full_messages.join(', ')
    end
    redirect_to(accounts_path)
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end

  def assign_user
    @user = current_user
  end
end
