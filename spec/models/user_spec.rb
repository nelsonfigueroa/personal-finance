# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:accounts).dependent(:destroy) }
    it { should have_many(:statements) }
    it { should have_many(:expense_trackers).dependent(:destroy) }
    it { should have_many(:expenses) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

    # name validations
    it { should allow_value(Faker::Alphanumeric.alpha).for(:name) }
    it { should_not allow_value(Faker::String.random).for(:name) }

    # email validations
    it { should allow_value(Faker::Internet.email).for(:email) }
    it { should_not allow_value(Faker::String.random).for(:email) }
  end
end
