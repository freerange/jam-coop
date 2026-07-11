# frozen_string_literal: true

require 'test_helper'

class PayoutPolicyTest < ActiveSupport::TestCase
  test '#index? returns true if user has Stripe Connect account accepting payments' do
    stripe_connect_account = create(:stripe_connect_account, charges_enabled: true)
    user = create(:user, stripe_connect_account:)

    policy = PayoutPolicy.new(user, Payout.all)
    assert policy.index?
  end

  test '#index? returns false if user has Stripe Connect account but not accepting payments' do
    stripe_connect_account = create(:stripe_connect_account, charges_enabled: false)
    user = create(:user, stripe_connect_account:)

    policy = PayoutPolicy.new(user, Payout.all)
    assert_not policy.index?
  end

  test '#index? returns false if user does not have Stripe Connect account' do
    user = create(:user)

    policy = PayoutPolicy.new(user, Payout.all)
    assert_not policy.index?
  end
end
