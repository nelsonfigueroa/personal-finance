# frozen_string_literal: true

class AddNotesToStatements < ActiveRecord::Migration[6.0]
  def change
    add_column :statements, :notes, :text, null: true
  end
end
