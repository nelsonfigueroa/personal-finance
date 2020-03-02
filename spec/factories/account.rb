FactoryBot.define do
  factory :account do
    name { Faker::Alphanumeric.alpha(number: 40) }
    user
  end
end