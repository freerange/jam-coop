# frozen_string_literal: true

require 'test_helper'

class PayoutTest < ActiveSupport::TestCase
  test 'factory is valid' do
    assert build(:payout).valid?
  end

  test 'payout_type is required' do
    assert_not build(:payout, payout_type: nil).valid?
  end

  test 'transaction_reference is required' do
    assert_not build(:payout, transaction_reference: nil).valid?
  end

  test 'destination_reference is required' do
    assert_not build(:payout, destination_reference: nil).valid?
  end

  test 'amount_in_pence is required' do
    assert_not build(:payout, amount_in_pence: nil).valid?
  end

  test 'platform_fee_in_pence is required' do
    assert_not build(:payout, platform_fee_in_pence: nil).valid?
  end

  test 'belongs to user' do
    user = build(:user)
    payout = create(:payout, user:)
    assert_equal user, payout.user
  end

  test 'has many purchases' do
    purchases = build_list(:purchase, 2)
    payout = create(:payout, purchases:)
    assert_equal purchases, payout.purchases
  end

  test 'foreign key on purchases is nullified on destruction' do
    purchases = build_list(:purchase, 2)
    payout = create(:payout, purchases:)
    payout.destroy!
    assert purchases.map(&:reload).map(&:payout).all?(&:nil?)
  end

  test 'is Stripe payout if payout_type is stripe' do
    payout = create(:stripe_payout)
    assert payout.stripe?
  end

  test 'is not Stripe payout if payout_type is not stripe' do
    payout = create(:payout)
    assert_not payout.stripe?
  end

  test 'amount is in pounds' do
    payout = create(:payout, amount_in_pence: 456)
    assert_in_delta 4.56, payout.amount, 0.001
  end
end
