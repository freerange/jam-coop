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
end
