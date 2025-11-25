# frozen_string_literal: true

require 'test_helper'

class StripeAccountsControllerCreateTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    log_in_as(@user)

    @stripe_account = stub('Stripe::Account', id: 'acct-id')
    Stripe::Account.stubs(:create).returns(@stripe_account)
  end

  test '#create creates a Stripe::Account' do
    Stripe::Account.expects(:create).returns(@stripe_account)

    post stripe_accounts_path
  end

  test '#create creates a StripeAccount to store the Stripe account ID' do
    post stripe_accounts_path

    account = StripeAccount.last
    assert_equal @user, account.user
    assert_equal @stripe_account.id, account.stripe_identifier
  end

  test '#create redirects to the account page' do
    post stripe_accounts_path

    assert_redirected_to account_path
  end
end
