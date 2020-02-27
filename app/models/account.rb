# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user

  validates :user, :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z ]+\z/ } # only letters
end
