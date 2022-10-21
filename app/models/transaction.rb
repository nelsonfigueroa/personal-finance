class Transaction < ApplicationRecord
	belongs_to :user
	validates :date, :category, :amount, presence: true

	monetize :amount_cents
end
