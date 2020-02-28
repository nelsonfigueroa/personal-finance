# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }

    # name validations
    it { should allow_value('My Account Name').for(:name) }
    it { should_not allow_value('123456', '', nil).for(:name) }
    it { should validate_length_of(:name).is_at_most(40) }
  end
end
