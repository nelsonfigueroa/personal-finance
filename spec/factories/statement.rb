FactoryBot.define do
  factory :statement do
    balance { Faker::Commerce.price(range: 0..100_000.0) }
    date { Faker::Date.in_date_period(year: 2018, month: 2) }
    account
  end
end