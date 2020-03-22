# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :assign_user
  before_action :assign_expense_tracker
  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    @expense.expense_tracker_id = @expense_tracker.id

    if @expense.save
      flash[:notice] = 'Expense created'
      redirect_to(expense_tracker_path(@expense_tracker))
    else
      flash[:alert] = @expense.errors.full_messages.join(', ')
      render('new')
    end
  end

  def edit
    @expense = @user.expense_trackers.find_by(id: @expense_tracker.id).expenses.find_by(id: params[:id])

    if @expense.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(expense_tracker_path(@expense_tracker))
    end
  end

  def update
    @expense = @user.expense_trackers.find_by(id: @expense_tracker.id).expenses.find_by(id: params[:id])

    if @expense.update(expense_params)
      flash[:notice] = 'Expense updated'
      redirect_to(expense_tracker_path(@expense_tracker))
    else
      flash[:alert] = @expense.errors.full_messages.join(', ')
      redirect_to(edit_expense_tracker_expense_path(expense_tracker_id: @expense_tracker.id, expense: @expense))
    end
  end

  def destroy
    # expenses should be destroyed when expense tracker is destroyed
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :date, :expense_tracker_id)
  end

  def assign_user
    @user = current_user
  end

  def assign_expense_tracker
    @expense_tracker = ExpenseTracker.find_by(id: params[:expense_tracker_id])
  end
end
