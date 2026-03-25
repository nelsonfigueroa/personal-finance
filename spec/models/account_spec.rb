# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:statements).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }

    it { should validate_length_of(:name).is_at_most(100) }
  end
end
