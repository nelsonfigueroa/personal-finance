class DividendsController < ApplicationController
# frozen_string_literal: true
    before_action :assign_user

    def index
        @dividends = @user.dividends
    end

    def show
        @dividend = @user.dividends.find_by(id: params[:id])

        return unless @dividend.nil?

        flash[:alert] = 'Invalid ID'
        redirect_to(dividends_path)
    end

    def new
        @dividend = Dividend.new
    end

    def edit
        @dividend = @user.dividends.find_by(id: params[:id])

        return unless @dividend.nil?

        flash[:alert] = 'Invalid ID'
        redirect_to(dividends_path)
    end

    def create
        @dividend = Dividend.new(dividend_params)
        @dividend.user_id = @user.id
        if @dividend.save
        flash[:notice] = 'Dividend created'
        redirect_to(dividends_path)
        else
        flash[:alert] = @dividend.errors.full_messages.join(', ')
        render('new')
        end
    end

    def update
        @dividend = @user.dividends.find_by(id: params[:id])
        if @dividend.update(dividend_params)
        flash[:notice] = 'Dividend updated'
        redirect_to(dividends_path)
        else
        flash[:alert] = @dividend.errors.full_messages.join(', ')
        redirect_to(edit_dividend_path(@dividend))
        end
    end

    def destroy
        @dividend = @user.dividends.find_by(id: params[:id])

        if @dividend.nil?
        flash[:alert] = 'Invalid ID'
        redirect_to(dividends_path) && return
        end

        if @dividend.destroy
        flash[:notice] = 'Dividend Deleted'
        else
        flash[:alert] = @dividend.errors.full_messages.join(', ')
        end
        redirect_to(dividends_path)
    end

    private

    def dividend_params
        params.require(:dividend).permit(:amount, :date, :ticker)
    end

    def assign_user
        @user = current_user
    end

end
