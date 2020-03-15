class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.references :expense_tracker, foreign_key: true, index: true
      t.decimal :amount, precision: 12, scale: 2
      t.date :date
      t.timestamps
    end
  end
end
