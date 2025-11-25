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

  test '#create redirects to the link action' do
    post stripe_accounts_path

    assert_redirected_to link_stripe_account_path(@stripe_account.id)
  end
end

class StripeAccountsControllerLinkTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    log_in_as(@user)

    @stripe_account_id = 'acct-id'
    StripeAccount.create!(user: @user, stripe_identifier: @stripe_account_id)

    url = success_stripe_account_url(@stripe_account_id)
    @stripe_account_link = stub('Stripe::AccountLink', url:)
    Stripe::AccountLink.stubs(:create).returns(@stripe_account_link)
  end

  test '#link creates a Stripe::AccountLink' do
    Stripe::AccountLink.expects(:create).with(
      {
        account: @stripe_account_id,
        refresh_url: link_stripe_account_url(@stripe_account_id),
        return_url: success_stripe_account_url(@stripe_account_id),
        type: 'account_onboarding'
      }
    ).returns(@stripe_account_link)

    get link_stripe_account_path(@stripe_account_id)
  end

  test '#link redirects to Stripe::AccountLink#url' do
    get link_stripe_account_path(@stripe_account_id)

    assert_redirected_to @stripe_account_link.url, allow_other_host: true
  end
end

class StripeAccountsControllerSuccessTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    log_in_as(@user)

    @stripe_account_id = 'acct-id'
    @account = StripeAccount.create!(user: @user, stripe_identifier: @stripe_account_id)

    @stripe_account = stub(
      'Stripe::Account', {
        id: @stripe_account_id,
        details_submitted?: false,
        charges_enabled?: false
      }
    )
  end

  test '#success updates StripeAccount#details_submitted?' do
    @stripe_account.stubs(details_submitted?: true)
    Stripe::Account.stubs(:retrieve).with(@stripe_account_id).returns(@stripe_account)

    get success_stripe_account_path(@stripe_account_id)

    assert @account.reload.details_submitted?
  end

  test '#success updates StripeAccount#charges_enabled?' do
    @stripe_account.stubs(charges_enabled?: true)
    Stripe::Account.stubs(:retrieve).with(@stripe_account_id).returns(@stripe_account)

    get success_stripe_account_path(@stripe_account_id)

    assert @account.reload.charges_enabled?
  end

  test '#success redirects to account page' do
    Stripe::Account.stubs(:retrieve).with(@stripe_account_id).returns(@stripe_account)

    get success_stripe_account_path(@stripe_account_id)

    assert_redirected_to account_path
  end
end
