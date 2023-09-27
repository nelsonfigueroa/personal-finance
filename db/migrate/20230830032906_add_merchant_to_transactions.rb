# frozen_string_literal: true

class AddMerchantToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :merchant, :string
  end
end
