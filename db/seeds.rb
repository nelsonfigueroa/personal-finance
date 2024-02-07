# frozen_string_literal: true

require 'faker'

User.create!([
               { name: 'Demo User', email: 'demo@demo', password: 'demouser123!', encrypted_password: '$2a$11$szyzQvo9zT6uthYP42uUCObOfkOyVr/amilyXYBknFDhHMy8BtyAO', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil }
             ])

# create 5 financial accounts for the user
5.times do
  Account.create!(user_id: 1, name: Faker::Bank.unique.name)
end

# each account gets 48 statements to cover a 4 year span
48.times do |i|
  i += 1
  date = Faker::Date.between(from: (49 - i).months.ago, to: (48 - i).months.ago)

  # for each account
  5.times do |x|
    x += 1
    Statement.create!(account_id: x, notes: 'notes', date: date, balance_cents: Faker::Number.between(from: (i * 100000), to: ((i + 1) * 150000)), balance_currency: 'USD')
  end
end

Category.create!([
  { user_id: 1, name: "Income", color: "#1cfc03" },
  { user_id: 1, name: "Interest", color: "#1cfc03" },
  { user_id: 1, name: "Rent", color: "#FFFFFF" },
  { user_id: 1, name: "Groceries", color: "#00bfff" },
  { user_id: 1, name: "Restaurants", color: "#ff0022" },
  { user_id: 1, name: "Car", color: "#ff0022" },
  { user_id: 1, name: "Shopping", color: "#eeff00" },
  { user_id: 1, name: "Games", color: "#03a5fc" }
])

# Income for 4 year span
48.times do |i|
  i += 1
  date = Faker::Date.between(from: (49 - i).months.ago, to: (48 - i).months.ago)
  Transaction.create!(user_id: 1, date: date, category_id: 1, notes: 'Salary', amount_cents: 400000, amount_currency: 'USD')
end

# Interest Earnings for 4 year span
48.times do |i|
  i += 1
  date = Faker::Date.between(from: (49 - i).months.ago, to: (48 - i).months.ago)
  Transaction.create!(user_id: 1, date: date, category_id: 2, notes: 'Interest Earned', amount_cents: 2000, amount_currency: 'USD')
end

# Rent for 4 year span
current_date = Date.current
# 4 Years
4.times do
  # 12 months
  12.times do
      Transaction.create!(user_id: 1, date: current_date, category_id: 3, notes: 'Rent', amount_cents: 200000, amount_currency: 'USD')
      # Move to previous month
      current_date = current_date.prev_month
  end

  # Move to the previous year
  current_date = current_date.prev_year
end

# Groceries for 4 year span
48.times do |i|
  i += 1
  date = Faker::Date.between(from: (49 - i).months.ago, to: (48 - i).months.ago)
  Transaction.create!(user_id: 1, date: date, category_id: 4, notes: 'Groceries', amount_cents: 100000, amount_currency: 'USD')
end

# Restaurants for 4 year span
48.times do |i|
  i += 1
  date = Faker::Date.between(from: (49 - i).months.ago, to: (48 - i).months.ago)
  Transaction.create!(user_id: 1, date: date, category_id: 5, notes: 'Food', amount_cents: 4000, amount_currency: 'USD')

  date = Faker::Date.between(from: (49 - i).months.ago, to: (48 - i).months.ago)
  Transaction.create!(user_id: 1, date: date, category_id: 5, notes: 'Food', amount_cents: 3500, amount_currency: 'USD')
end
