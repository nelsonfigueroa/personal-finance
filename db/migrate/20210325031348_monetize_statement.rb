# frozen_string_literal: true

class MonetizeStatement < ActiveRecord::Migration[6.1]
  def change
    add_monetize :statements, :balance
  end
end
