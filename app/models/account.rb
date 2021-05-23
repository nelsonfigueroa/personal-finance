# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :statements, dependent: :destroy

  validates :user, :name, presence: true
  validates :name, length: { maximum: 40 }

  scope :sorted_by_name, -> { order(name: :asc) }
end
