# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    amount { Faker::Commerce.price(range: 0..100_000.0) }
    date { Faker::Date.in_date_period(year: 2018, month: 2) }
    expense_tracker
  end
end
