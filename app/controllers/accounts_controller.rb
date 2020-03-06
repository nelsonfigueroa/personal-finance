# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :assign_user

  def index
    @accounts = @user.accounts

    @net_worth = @user.statements.sorted_by_date.pluck(:date, :balance)

    # by adding this output to the view: <%= @net_worth %>
    # we can see that the format is arrays within an array
    # find a way to generate total balance for a given day.

    # maybe it's best to store this in a database so it's faster
    # maybe this is a good case for service objects?
    # whenever a user adds a statement, save statement and also modify
    # the database that calculates net worth.
    # table could be called worth or something.

    # for now just add private methods to controller

    # but how would this work?
    # everytime a user modified or creates a statement we need to calculate net worth
    # and the hard part is taking into account the dates.

    # when a statment is added, sum net worth and save to database
    # 

    # also, implement the route for displaying chartkick
    # it's much faster.
    # then maybe write specs for this?


    # you can try .maximum(:balance)
    # there's also .sum(:balance)

    # maybe create a method of total_net_worth_on(date)
    # and it gets all statements up to that date and adds up balance

    # but chartkick wants data. So i'd have to create BS data just to fill the dots

    # apparently spanGaps: true should fix it but idk if that option is implemented in Ruby
    # https://github.com/ankane/vue-chartkick/issues/34
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
