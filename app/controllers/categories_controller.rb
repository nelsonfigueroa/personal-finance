# frozen_string_literal: true

class CategoriesController < ApplicationController
  # frozen_string_literal: true
  before_action :assign_user

  def index
    @categories = @user.categories
  end

  def show
    @category = @user.categories.find_by(id: params[:id])
    if @category.nil?
      redirect_to categories_path, alert: 'Invalid ID'
      return
    end

    @transactions = @category.transactions.sorted_by_date
  end

  def new
    @category = Category.new
  end

  def edit
    @category = @user.categories.find_by(id: params[:id])
    return unless @category.nil?

    redirect_to categories_path, alert: 'Invalid ID'
    nil
  end

  def create
    @category = Category.new(category_params)
    @category.user_id = @user.id
    if @category.save
      flash[:notice] = 'Category created'
      redirect_to(categories_path)
    else
      flash[:alert] = @category.errors['name'][0]
      redirect_to(new_category_path)
    end
  end

  def update
    @category = @user.categories.find_by(id: params[:id])
    if @category.update(category_params)
      flash[:notice] = 'Category updated'
      redirect_to(categories_path)
    else
      flash[:alert] = @category.errors.full_messages.join(', ')
      redirect_to(edit_category_path(@category))
    end
  end

  def destroy
    @category = @user.categories.find_by(id: params[:id])

    if @category.nil?
      flash[:alert] = 'Invalid ID'
      redirect_to(categories_path) && return
    end

    if @category.destroy
      flash[:notice] = 'Category Deleted'
    else
      flash[:alert] = @category.errors.full_messages.join(', ')
    end
    redirect_to(categories_path)
  end

  private

  def category_params
    params.require(:category).permit(:name, :color)
  end

  def assign_user
    @user = current_user
  end
end
