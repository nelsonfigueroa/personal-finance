class AddUniqueIndexToStatements < ActiveRecord::Migration[6.1]
  def change
    add_index :statements, [:account_id, :date], unique: true
  end
end
