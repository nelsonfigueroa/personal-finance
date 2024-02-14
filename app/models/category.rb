# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :nullify

  validates :name, presence: true
  validates :color, presence: true, format: { with: /\A#?(?:[0-9a-fA-F]{3}){1,2}\z/, message: 'must be a valid hex color' }
  validates :name, uniqueness: { scope: :user_id, message: 'you already have a category with this name' }
end
