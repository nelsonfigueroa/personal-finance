# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user
  validates :date, :category, :amount, presence: true
  validates :amount, numericality: true

  monetize :amount_cents

  scope :sorted_by_date, -> { order(date: :desc) }

  # https://stackoverflow.com/questions/9624601/activerecord-find-by-year-day-or-month-on-a-date-field
  def self.by_year(year)
    dt = DateTime.new(year)
    boy = dt.beginning_of_year
    eoy = dt.end_of_year
    where('date >= ? and date <= ?', boy, eoy)
  end
end
