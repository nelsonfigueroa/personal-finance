# frozen_string_literal: true

require 'faker'

User.create!([
               { name: 'Demo User', email: 'demo@demo', password: 'demouser123!', encrypted_password: '$2a$11$szyzQvo9zT6uthYP42uUCObOfkOyVr/amilyXYBknFDhHMy8BtyAO', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil }
             ])

# create 5 accounts for the user
5.times do
  Account.create!(user_id: 1, name: Faker::Bank.unique.name)
end

# each account gets 24 statements to cover a 2 year span
24.times do |i|
  i += 1
  date = Faker::Date.between(from: (25 - i).months.ago, to: (24 - i).months.ago)

  # for each account
  5.times do |x|
    x += 1
    Statement.create!(account_id: x, notes: 'notes', date: date, balance_cents: Faker::Number.between(from: (i * 100000), to: ((i + 1) * 150000)), balance_currency: 'USD')
  end
end

Category.create!([
  { user_id: 1, name: "Income", color: "#1cfc03" }
  { user_id: 1, name: "Interest", color: "#1cfc03" },
  { user_id: 1, name: "Rent", color: "#FFFFFF" },
  { user_id: 1, name: "Groceries", color: "#00bfff" },
  { user_id: 1, name: "Restaurants", color: "#ff0022" },
  { user_id: 1, name: "Car", color: "#ff0022" },
  { user_id: 1, name: "Shopping", color: "#eeff00" },
  { user_id: 1, name: "Games", color: "#03a5fc" },
])

# Rent for 2 year span
24.times do |i|
  i += 1
  date = Faker::Date.between(from: (25 - i).months.ago, to: (24 - i).months.ago)
  Transaction.create!(user_id: 1, date: date, category_id: 2, notes: 'Rent', amount_cents: 200000, amount_currency: 'USD')
end

# Income for 2 year span
24.times do |i|
  i += 1
  date = Faker::Date.between(from: (25 - i).months.ago, to: (24 - i).months.ago)
  Transaction.create!(user_id: 1, date: date, category_id: 1, notes: 'Salary', amount_cents: 400000, amount_currency: 'USD')
end