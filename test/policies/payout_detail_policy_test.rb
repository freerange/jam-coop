# frozen_string_literal: true

require 'test_helper'

class PayoutDetailPolicyTest < ActiveSupport::TestCase
  test 'a user' do
    record = build(:payout_detail)
    policy = PayoutDetailPolicy.new(record.user, record)

    assert policy.new?
    assert policy.create?
  end
end
