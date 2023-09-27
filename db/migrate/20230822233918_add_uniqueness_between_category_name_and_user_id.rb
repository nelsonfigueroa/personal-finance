# frozen_string_literal: true

class AddUniquenessBetweenCategoryNameAndUserId < ActiveRecord::Migration[7.0]
  def change
    change_table :categories do |t|
      t.index %i[name user_id], unique: true # category name and account_id are unique together
    end
  end
end
