class MonetizeDividend < ActiveRecord::Migration[7.0]
  def change
    add_monetize :dividends, :amount
  end
end
