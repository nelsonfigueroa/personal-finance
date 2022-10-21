class MonetizeTransaction < ActiveRecord::Migration[6.1]
  def change
    add_monetize :transactions, :amount
  end
end
