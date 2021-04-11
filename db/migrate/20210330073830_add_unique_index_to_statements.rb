# frozen_string_literal: true

class AddUniqueIndexToStatements < ActiveRecord::Migration[6.1]
  def change
    add_index :statements, %i[account_id date], unique: true
  end
end
