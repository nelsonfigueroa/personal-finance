# frozen_string_literal: true

class DropDividends < ActiveRecord::Migration[7.1]
  def change
    drop_table :dividends, if_exists: true
  end
end
