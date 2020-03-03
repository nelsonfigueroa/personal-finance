# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { Faker::Alphanumeric.alpha(number: 40) }
    user
  end
end
