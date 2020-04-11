# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { should belong_to(:expense_tracker) }
  end

  describe 'validations' do
    it { should validate_presence_of(:expense_tracker) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:date) }
    it {
      should validate_numericality_of(:amount)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(BigDecimal(10**8))
    }

    # amount
    it { should allow_value(Faker::Commerce.price).for(:amount) }
    it { should_not allow_value(Faker::String.random).for(:amount) }

    # date
    it { should allow_value(Faker::Date.between(from: 14.days.ago, to: Date.today)).for(:date) }
    it { should_not allow_value(Faker::String.random).for(:date) }
  end
end
