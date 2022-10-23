class TransactionsController < ApplicationController
  before_action :assign_user

  def index
    @transactions = @user.transactions
  end

  def show
    @transaction = @user.transactions.find_by(id: params[:id])

    if @transaction.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(transactions_path)
    end
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user_id = @user.id
    puts "I think it's working"
    if @transaction.save
      flash[:notice] = 'Transaction created'
      redirect_to(transactions_path)
    else
      flash[:alert] = @transaction.errors.full_messages.join(', ')
      render('new')
    end
  end

  def edit
    @transaction = @user.transactions.find_by(id: params[:id])

    if @transaction.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(transactions_path)
    end
  end

  def update
    @transaction = @user.transactions.find_by(id: params[:id])
    if @transaction.update(transaction_params)
      flash[:notice] = 'Transaction updated'
      redirect_to(transactions_path)
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

  private

  def transaction_params
    params.require(:transaction).permit(:category, :amount, :date, :notes)
  end

  def assign_user
    @user = current_user
  end
end
