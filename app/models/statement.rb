# frozen_string_literal: true

class Statement < ApplicationRecord
  belongs_to :account

  validates :balance, :date, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0,
                                      less_than_or_equal_to: BigDecimal(10**8) }
end
