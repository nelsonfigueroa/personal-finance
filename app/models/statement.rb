# frozen_string_literal: true

class Statement < ApplicationRecord
  belongs_to :account

  monetize :balance_cents

  validates :account, :balance, :date, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0,
                                      less_than_or_equal_to: 1_000_000_000 }

  scope :sorted_by_date, -> { order(date: :asc) }
  scope :sorted_by_balance, -> { order(balance: :desc) }
end
