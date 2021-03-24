# frozen_string_literal: true

class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.references :expense_tracker, foreign_key: true, index: true
      t.integer :amount
      t.date :date
      t.timestamps
    end
  end
end
