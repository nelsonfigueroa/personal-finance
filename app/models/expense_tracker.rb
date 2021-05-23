# frozen_string_literal: true

class ExpenseTracker < ApplicationRecord
  belongs_to :user
  has_many :expenses, dependent: :destroy

  validates :user, :category, presence: true
  validates :category, length: { maximum: 40 }, format: { with: /\A[a-zA-Z ]+\z/ } # only letters
end
