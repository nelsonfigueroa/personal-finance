class StatementsController < ApplicationController
	before_action :assign_user
	before_action :assign_account, only: %i[create edit update]

	def new 
		@statement = Statement.new
	end

	def create
		@statement = Statement.new(statement_params)

		# keep here for security
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
		# these should be destroyed when an account is destroyed
	end

	private

	def statement_params
		params.require(:statement).permit(:balance, :date, :account_id)
	end

	def assign_user
		@user = current_user
	end

	def assign_account
		@account = Account.find_by(id: params[:account_id])
	end
end
