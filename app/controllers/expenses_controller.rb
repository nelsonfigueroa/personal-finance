class ExpensesController < ApplicationController
  before_action :assign_user
  before_action :assign_account, only: %i[create edit update]

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
