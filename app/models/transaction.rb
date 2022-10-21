class Transaction < ApplicationRecord
	validates :date, :category, :amount, presence: true
end
