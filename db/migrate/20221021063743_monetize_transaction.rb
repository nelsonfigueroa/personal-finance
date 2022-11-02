# frozen_string_literal: true

class MonetizeTransaction < ActiveRecord::Migration[6.1]
  def change
    add_monetize :transactions, :amount
  end
end
