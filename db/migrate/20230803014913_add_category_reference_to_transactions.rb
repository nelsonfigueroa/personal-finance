class AddCategoryReferenceToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :transactions, :category, null: true, foreign_key: true
  end
end
