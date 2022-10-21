class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.date :date
      t.string :category, index: true
      t.text :notes, null: true
    end
  end
end

# amount is handled via money-rails gem