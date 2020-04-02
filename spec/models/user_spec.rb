# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:accounts) }
    it { should have_many(:statements) }
    it { should have_many(:expense_trackers) }
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

  describe '#has_statement_this_month?' do
    let!(:user) { create(:user) }
    let(:account) { create(:account, user: user) }
    let(:statement) { create(:statement, account: account) }

    context 'if there is no statement for the current month' do
      it 'returns false' do
        expect(user.has_statement_this_month?(account)).to be(false)
      end
    end

    context 'if there is a statement for the current month' do
      it 'returns true' do
        statement.date = Faker::Date.in_date_period(year: 2020, month: Time.zone.today.month)
        statement.save!
        expect(user.has_statement_this_month?(account)).to be(true)
      end
    end
  end
end
