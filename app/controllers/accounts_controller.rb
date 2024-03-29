# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :assign_user

  def index
    @accounts = @user.accounts.sorted_by_name.includes([:statements])

    @net_worth = 0

    return if @user.statements.empty?

    # get the last statement for each account to determine net worth
    @accounts.each do |account|
      next if account.statements.empty?

      @net_worth += account.statements.sorted_by_date.last.balance_cents
    end
    @net_worth /= 100.0
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

  def edit
    @account = @user.accounts.find_by(id: params[:id])

    return unless @account.nil?

    flash[:alert] = 'Invalid ID'
    redirect_to(accounts_path)
  end

  def create
    @account = Account.new(account_params)
    @account.user_id = @user.id

    if @account.save
      flash[:notice] = 'Account created'
      redirect_to(accounts_path)
    else
      flash[:alert] = @account.errors.full_messages.join(', ')
      render('new')
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

    if @account.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(accounts_path) && return
    end

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
