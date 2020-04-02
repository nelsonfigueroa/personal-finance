# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :accounts, dependent: :destroy
  has_many :statements, through: :accounts
  has_many :expense_trackers, dependent: :destroy
  has_many :expenses, through: :expense_trackers

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, format: { with: /\A[a-zA-Z ]+\z/ } # only letters

  def has_statement_this_month?(account)
    account.statements.where(date: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month).exists?
  end
end
