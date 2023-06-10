# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :pwned_password

  has_many :accounts, dependent: :destroy
  has_many :statements, through: :accounts
  has_many :transactions, dependent: :destroy
  has_many :dividends, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, format: { with: /\A[a-zA-Z ]+\z/ } # only letters
end
