# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:category) }

    # idk how to test for money-rails
    # it { should validate_presence_of(:amount_cents) }

    it { should validate_numericality_of(:amount_cents) }

    # amount
    it { should allow_value(Faker::Commerce.price).for(:amount_cents) }
    it { should_not allow_value(Faker::String.random).for(:amount) }

    # date
    it { should allow_value(Faker::Date.between(from: 14.days.ago, to: Time.zone.today)).for(:date) }
    it { should_not allow_value(Faker::String.random).for(:date) }

    # category
    it { should_not allow_value(nil).for(:category) }
    it { should allow_value('Testing12345 67890!@#  $%^&*()-_+=.:;/\[]\'",?').for(:category) }
  end
end
