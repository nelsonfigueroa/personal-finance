# frozen_string_literal: true

class CreateStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :statements do |t|
      t.references :account, foreign_key: true, index: true
      t.integer :balance
      t.date :date
      t.timestamps
    end
  end
end
