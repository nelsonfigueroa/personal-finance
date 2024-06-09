# frozen_string_literal: true

class ResetAllTransactionCacheCounters < ActiveRecord::Migration[7.1]
  def change
    Category.find_each do |category|
      Category.reset_counters(category.id, :transactions)
    end
  end
end
