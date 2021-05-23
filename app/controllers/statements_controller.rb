# frozen_string_literal: true

class StatementsController < ApplicationController
  before_action :assign_user
  before_action :assign_account

  def new
    @statement = Statement.new
  end

  def create
    @statement = Statement.new(statement_params)
    @statement.account_id = @account.id

    if @statement.save
      flash[:notice] = 'Statement created'
      redirect_to(account_path(@account))
    else
      flash[:alert] = @statement.errors.full_messages.join(', ')
      render('new')
    end
  end

  def edit
    @statement = @user.accounts.find_by(id: @account.id).statements.find_by(id: params[:id])

    if @statement.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(account_path(@account))
    end
  end

  def update
    @statement = @user.accounts.find_by(id: @account.id).statements.find_by(id: params[:id])

    if @statement.update(statement_params)
      flash[:notice] = 'Statement updated'
      redirect_to(account_path(@account))
    else
      flash[:alert] = @statement.errors.full_messages.join(', ')
      redirect_to(edit_account_statement_path(account_id: @account.id, statement: @statement))
    end
  end

  def destroy
    @statement = @user.accounts.find_by(id: @account.id).statements.find_by(id: params[:id])

    if @statement.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(account_path(@account.id)) && return
    end

    if @statement.destroy
      flash[:notice] = 'Statement Deleted'
    else
      flash[:alert] = @statement.errors.full_messages.join(', ')
    end
    redirect_to(account_path(@account.id))
  end

  private

  def statement_params
    params.require(:statement).permit(:balance, :date, :notes)
  end

  def assign_user
    @user = current_user
  end

  def assign_account
    @account = @user.accounts.find_by(id: params[:account_id])
  end
end
