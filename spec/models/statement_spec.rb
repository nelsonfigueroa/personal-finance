# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Statement, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:date) }
    it { should validate_numericality_of(:balance_cents) }

    # balance
    it { should allow_value(Faker::Commerce.price).for(:balance_cents) }
    it { should_not allow_value(Faker::String.random).for(:balance) }

    # date
    it { should allow_value(Faker::Date.between(from: 14.days.ago, to: Time.zone.today)).for(:date) }
    it { should_not allow_value(Faker::String.random).for(:date) }

    # notes
    it { should allow_value(nil).for(:notes) }
    it { should allow_value('Testing12345 67890!@#  $%^&*()-_+=.:;/\[]\'",?').for(:notes) }
  end
end
