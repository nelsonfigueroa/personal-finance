class Category < ApplicationRecord
    belongs_to :user
    has_many :transactions

    validates :color, presence: true, format: { with: /\A#?(?:[0-9a-fA-F]{3}){1,2}\z/, message: "must be a valid hex color" }
end
