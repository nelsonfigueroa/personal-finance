# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :assign_user

  def index
    @accounts = @user.accounts
    @net_worth = @user.statements.sum(:balance)

    # for chartkick
    # @net_worth = @user.statements.sorted_by_date.pluck(:date, :balance)
    # @net_worth = @user.statements.group_by_day(:date).maximum(:balance)

    # this just gets statements
    # need to add up net worth over time
    # so each statement needs to stack on top of the previous one 
    # how do i do that
    # first worry about connecting the graph gaps
    # then worry about implementation of net worth
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
    # should destroy all entries/logs as well. dependent_destroy
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end

  def assign_user
    @user = current_user
  end
end
