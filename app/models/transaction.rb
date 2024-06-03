# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category, counter_cache: true
  validates :date, :category, :amount, presence: true
  validates :amount, numericality: true

  monetize :amount_cents

  scope :sorted_by_date, -> { order(date: :desc) }

  # https://stackoverflow.com/questions/9624601/activerecord-find-by-year-day-or-month-on-a-date-field
  def self.by_year(year)
    datetime = DateTime.new(year)
    beginning_of_year = datetime.beginning_of_year.to_date
    end_of_year = datetime.end_of_year.to_date
    where('date >= ? and date <= ?', beginning_of_year, end_of_year)
  end
end
