# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Statement, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of(:balance) }
    it { should validate_presence_of(:date) }
    it {
      should validate_numericality_of(:balance)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(BigDecimal(10**8))
    }
    it { should allow_value(nil).for(:notes) }
  end
end
