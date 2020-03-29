# frozen_string_literal: true

class ExpenseTrackersController < ApplicationController
  before_action :assign_user

  def index
    @expense_trackers = @user.expense_trackers.order(:category)
    
    # total expenses for current month
    @expenses_this_month = @user.expenses.where(date: Date.current.beginning_of_month..Date.current.end_of_month).sum(:amount)
  end

  def show
    @expense_tracker = @user.expense_trackers.find_by(id: params[:id])

    if @expense_tracker.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(expense_trackers_path)
    else
      @expenses = @expense_tracker.expenses
    end
  end

  def new
    @expense_tracker = ExpenseTracker.new
  end

  def create
    @expense_tracker = ExpenseTracker.new(expense_tracker_params)
    @expense_tracker.user_id = @user.id

    if @expense_tracker.save
      flash[:notice] = 'Expense Tracker created'
      redirect_to(expense_trackers_path)
    else
      flash[:alert] = @expense_tracker.errors.full_messages.join(', ')
      render('new')
    end
  end

  def edit
    @expense_tracker = @user.expense_trackers.find_by(id: params[:id])

    if @expense_tracker.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(expense_trackers_path)
    end
  end

  def update
    @expense_tracker = @user.expense_trackers.find_by(id: params[:id])

    if @expense_tracker.update(expense_tracker_params)
      flash[:notice] = 'Expense Tracker Updated'
      redirect_to(@expense_tracker)
    else
      flash[:alert] = @expense_tracker.errors.full_messages.join(', ')
      redirect_to(edit_expense_tracker_path(@expense_tracker))
    end
  end

  def destroy
    @expense_tracker = @user.expense_trackers.find_by(id: params[:id])

    if @expense_tracker.destroy
      flash[:notice] = 'Expense Tracker Deleted'
    else
      flash[:alert] = @expense_tracker.errors.full_messages.join(', ')
    end
    redirect_to(expense_trackers_path)
  end

  private

  def expense_tracker_params
    params.require(:expense_tracker).permit(:category)
  end

  def assign_user
    @user = current_user
  end
end
