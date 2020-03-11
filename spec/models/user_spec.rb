# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:accounts) }
    it { should have_many(:statements) }
    it { should have_many(:expense_trackers) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end
end
