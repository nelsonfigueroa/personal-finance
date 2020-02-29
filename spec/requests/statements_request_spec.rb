# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Statement Requests', type: :request do
  let(:user) do
    User.create(email: Faker::Internet.email,
                name: Faker::Name.first_name,
                password: Faker::Internet.password)
  end

  let(:account) do
    Account.create(name: Faker::Alphanumeric.alpha(number: 40),
                   user: user)
  end

  let(:statement) do
    Statement.create(balance: Faker::Commerce.price(range: 0..100_000.0),
                     date: Faker::Date.in_date_period(year: 2018, month: 2),
                     account: account)
  end
end
