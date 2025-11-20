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

  test 'is invalid without stripe identifier' do
    @account.stripe_identifier = nil
    assert_not @account.valid?
  end

  test '#details_submitted? is false by default' do
    assert_not @account.details_submitted?
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

  test "#status returns 'not_started' if #details_submitted? or #charges_enabled? are both false" do
    @account.assign_attributes(details_submitted: false, charges_enabled: false)
    assert_equal 'not_started', @account.status
  end

  test "#status returns 'details_submitted' if #details_submitted? is true & #charges_enabled? is false" do
    @account.assign_attributes(details_submitted: true, charges_enabled: false)
    assert_equal 'details_submitted', @account.status
  end

  test "#status returns 'charges_enabled' if #charges_enabled? is true" do
    @account.assign_attributes(details_submitted: false, charges_enabled: true)
    assert_equal 'charges_enabled', @account.status

    @account.assign_attributes(details_submitted: true, charges_enabled: true)
    assert_equal 'charges_enabled', @account.status
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
