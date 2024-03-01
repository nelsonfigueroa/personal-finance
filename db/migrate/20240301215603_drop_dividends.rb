class DropDividends < ActiveRecord::Migration[7.1]
  def change
      drop_table :dividends
  end
end
