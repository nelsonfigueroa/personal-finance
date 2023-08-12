# frozen_string_literal: true

# Accounts have statements that are used to keep track of net worth
class Account < ApplicationRecord
  belongs_to :user
  has_many :statements, dependent: :destroy

  validates :user, :name, presence: true
  validates :name, length: { maximum: 100 }

  scope :sorted_by_name, -> { order(name: :asc) }
end
