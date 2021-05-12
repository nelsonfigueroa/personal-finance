# frozen_string_literal: true

class CreateStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :statements do |t|
      t.references :account, foreign_key: true, index: true
      t.text :notes, :text, null: true
      t.date :date
      t.index %i[date account_id], unique: true # date and account_id are unique together
      t.timestamps
    end
  end
end
