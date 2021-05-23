# frozen_string_literal: true

FactoryBot.define do
  factory :statement do
    balance { Faker::Commerce.price(range: 0..100_000.0) }
    date { Faker::Date.in_date_period(year: 2020, month: 2) }
    notes { Faker::Alphanumeric.alphanumeric(number: 10) }
    account
  end
end
