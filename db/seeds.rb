# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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

5.times do
  Statement.create(
    balance: Faker::Commerce.price(range: 0..100_000.0),
    date: Faker::Date.in_date_period(year: 2019, month: 12),
    account: account
  )
end

5.times do
  ExpenseTracker.create(
    category: Faker::Commerce.department(max: 1),
    user: user
  )
end

25.times do
  Expense.create(
    amount: Faker::Commerce.price(range: 0..100_000.0),
    date: Faker::Date.in_date_period(year: 2018, month: 2),
    expense_tracker: ExpenseTracker.all.sample
  )
end
