class CreateExpenseTrackers < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_trackers do |t|
      t.references :user, foreign_key: true, index: true
      t.string :category, length: 40
      t.timestamps
    end
  end
end
