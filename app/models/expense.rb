class Expense < ApplicationRecord
  belongs_to :expense_tracker

  validates :amount, :date, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0,
              less_than_or_equal_to: BigDecimal(10**8) }
end
