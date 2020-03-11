# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpenseTracker, type: :model do
  it { should belong_to(:user) }

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:category) }

    # category validations
    it { should allow_value(Faker::Alphanumeric.alpha(number: 40)).for(:category) }
    it { should_not allow_value(Faker::Alphanumeric.alphanumeric(number: 40, min_numeric: 1), '123456', '', nil).for(:category) }
    it { should validate_length_of(:category).is_at_most(40) }
  end
end
