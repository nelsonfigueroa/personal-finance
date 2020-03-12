# frozen_string_literal: true

class ExpenseTrackersController < ApplicationController
  before_action :assign_user

  def index
    @expense_trackers = @user.expense_trackers
  end

  def show
    @expense_tracker = @user.expense_trackers.find_by(id: params[:id])

    if @expense_tracker.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(expense_trackers_path)
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
    # should delete expenses associated, dependent_destroy
  end

  private

  def expense_tracker_params
    params.require(:expense_tracker).permit(:category)
  end

  def assign_user
    @user = current_user
  end
end
