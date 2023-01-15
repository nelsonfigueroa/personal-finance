# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do
  describe 'GET /dashboard' do
    let(:net_worth) { user.statements.where(date: Time.zone.today.all_month).sum(:balance_cents) }
    pending "add some examples (or delete) #{__FILE__}"
  end
end
