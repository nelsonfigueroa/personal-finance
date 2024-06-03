class ResetAllTransactionCacheCounters < ActiveRecord::Migration[7.1]
  def change
    Category.all.each do |category|
      Category.reset_counters(category.id, :transactions)
    end
  end
end
