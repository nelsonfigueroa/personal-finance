# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true, index: true
      t.string :name, length: 100
      t.timestamps
    end
  end
end
