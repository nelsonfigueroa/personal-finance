# frozen_string_literal: true

class Statement < ApplicationRecord
  belongs_to :account

  validates :balance, :date, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0,
                                      less_than_or_equal_to: BigDecimal(10**8) }

  scope :sorted_by_date, -> { order(date: :desc) }
  scope :sorted_by_balance, -> { order(balance: :desc) }
end
