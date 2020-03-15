# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { should belong_to(:expense_tracker) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:date) }
    it {
      should validate_numericality_of(:amount)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(BigDecimal(10**8))
    }
  end
end
