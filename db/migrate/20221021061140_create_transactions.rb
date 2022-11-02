# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true, index: true
      t.date :date
      t.string :category, index: true
      t.text :notes, null: true
    end
  end
end

# amount is handled via money-rails gem
