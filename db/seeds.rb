# frozen_string_literal: true

require 'faker'

user = User.create(
  email: Faker::Internet.email,
  name: Faker::Name.first_name,
  password: Faker::Internet.password
)

account = Account.create(
  name: Faker::Alphanumeric.alpha(number: 40),
  user: user
)

i = 1
min_balance = 10000.0
max_balance = 20000.0
12.times do
  Statement.create(
    balance: Faker::Commerce.price(range: min_balance..max_balance),
    date: Faker::Date.in_date_period(year: 2019, month: i),
    account: account
  )
  i = i + 1
  min_balance = min_balance + 10000.0
  max_balance = max_balance + 10000.0
end

5.times do
  ExpenseTracker.create(
    category: Faker::Commerce.department(max: 1),
    user: user
  )
end

25.times do
  Expense.create(
    amount: Faker::Commerce.price(range: 0..50.0),
    date: Faker::Date.in_date_period(year: 2018, month: 2),
    expense_tracker: ExpenseTracker.all.sample
  )
end
