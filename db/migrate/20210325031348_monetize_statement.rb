class MonetizeStatement < ActiveRecord::Migration[6.1]
  def change
    add_monetize :statements, :balance
  end
end
