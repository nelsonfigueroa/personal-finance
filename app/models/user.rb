# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :accounts
  has_many :statements, through: :accounts
  has_many :expense_trackers

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
