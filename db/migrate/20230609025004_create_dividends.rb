class CreateDividends < ActiveRecord::Migration[7.0]
  def change
    create_table :dividends do |t|
      t.references :user, foreign_key: true, index: true
      t.date :date
      t.string :ticker, index: true
    end
  end
end
