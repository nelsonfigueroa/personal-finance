# frozen_string_literal: true

class Statement < ApplicationRecord
  belongs_to :account

  validates :account, :balance, :date, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0,
                                      less_than_or_equal_to: BigDecimal(10**8) }
  validates :notes, allow_nil: true, format: { with: /\A[\w\s[[:punct:]]]+\z/ }

  scope :sorted_by_date, -> { order(date: :desc) }
  scope :sorted_by_balance, -> { order(balance: :desc) }
end
