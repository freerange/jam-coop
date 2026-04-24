# frozen_string_literal: true

require 'test_helper'

class StripeConnectAccountTest < ActiveSupport::TestCase
  setup do
    @account = build(:stripe_connect_account)
  end

  test 'factory is valid' do
    assert @account.valid?
  end

  test 'is invalid without user' do
    @account.user = nil
    assert_not @account.valid?
  end

  test '#details_submitted? is false by default' do
    assert_not @account.details_submitted?
  end

  test 'is invalid without country code' do
    @account.country_code = nil
    assert_not @account.valid?
    assert_equal ["can't be blank"], @account.errors[:country_code]
  end

  test 'is invalid when country code is not GB' do
    @account.country_code = 'FR'
    assert_not @account.valid?
    assert_equal ['is not supported'], @account.errors[:country_code]
  end

  test '#details_submitted? can be set to true' do
    @account.details_submitted = true
    assert @account.details_submitted?
  end

  test '#charges_enabled? is false by default' do
    assert_not @account.charges_enabled?
  end

  test '#charges_enabled can be set to true' do
    @account.charges_enabled = true
    assert @account.charges_enabled?
  end

  test '#payouts_enabled? is false by default' do
    assert_not @account.payouts_enabled?
  end

  test '#payouts_enabled can be set to true' do
    @account.payouts_enabled = true
    assert @account.payouts_enabled?
  end

  test '#accepts_payments? is false if status is not_started' do
    @account.assign_attributes(details_submitted: false, charges_enabled: false)
    assert_not @account.accepts_payments?
  end

  test '#accepts_payments? is false if status is details_submitted' do
    @account.assign_attributes(details_submitted: true, charges_enabled: false)
    assert_not @account.accepts_payments?
  end

  test '#accepts_payments? is true if status is charges_enabled' do
    @account.assign_attributes(details_submitted: true, charges_enabled: true)
    assert @account.accepts_payments?
  end
end
