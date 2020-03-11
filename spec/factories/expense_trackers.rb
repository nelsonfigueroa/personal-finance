FactoryBot.define do
  factory :expense_tracker do
    category { Faker::Commerce.department(max: 1) }
    user
  end
end
