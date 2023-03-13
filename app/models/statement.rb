# frozen_string_literal: true

# statements are associated to accounts and track ending balances for a certain date. Used for net worth calculation.
class Statement < ApplicationRecord
  belongs_to :account

  monetize :balance_cents

  validates :account, :balance, :date, presence: true
  validates :balance, numericality: true
  # uses uniqueness defined in migration. date and account_id are unique together
  validates :date, uniqueness: { scope: :account_id, message: 'you already have a statement for this date' }

  scope :sorted_by_date, -> { order(date: :asc) }
  scope :sorted_by_balance, -> { order(balance: :desc) }

  # https://stackoverflow.com/questions/9624601/activerecord-find-by-year-day-or-month-on-a-date-field
  # going back 3 years by default
  def self.from_year(year)
    datetime = DateTime.new(year - 3)
    beginning_of_year = datetime.beginning_of_year

    datetime = DateTime.new(year)
    end_of_year = datetime.end_of_year
    where('date >= ? and date <= ?', beginning_of_year, end_of_year)
  end
end
