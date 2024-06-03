class AddTransactionsCountToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :transactions_count, :integer
  end
end
