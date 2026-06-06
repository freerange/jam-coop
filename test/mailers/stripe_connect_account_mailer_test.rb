# frozen_string_literal: true

require 'test_helper'

class StripeConnectAccountMailerTest < ActionMailer::TestCase
  test 'charges_enabled' do
    account = build(:stripe_connect_account)

    mail = StripeConnectAccountMailer.with(account:).charges_enabled

    assert_equal 'Your Stripe account now accepts payments', mail.subject
    assert_equal [account.user.email], mail.to
  end

  test 'payouts_enabled' do
    account = build(:stripe_connect_account)

    mail = StripeConnectAccountMailer.with(account:).payouts_enabled

    assert_equal 'Your Stripe account now allows payouts', mail.subject
    assert_equal [account.user.email], mail.to
  end
end
