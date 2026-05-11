# frozen_string_literal: true

require 'test_helper'

class StripeConnectAccountsControllerCreateTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, stripe_connect_enabled: true)
    log_in_as(@user)

    @stripe_account = stub('Stripe::Account', id: 'acct-id')
    Stripe::Account.stubs(:create).returns(@stripe_account)
  end

  test '#create redirects to account page if Stripe Connect is disabled for user' do
    @user.update!(stripe_connect_enabled: false)
    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: 'GB' } }

    assert_redirected_to account_path
    assert_equal 'Stripe Connect is not available', flash[:alert]
  end

  test '#create creates a Stripe::Account' do
    Stripe::Account.expects(:create).with({ email: @user.email, country: 'GB' }).returns(@stripe_account)

    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: 'GB' } }
  end

  test '#create creates a StripeConnectAccount to store the Stripe account ID' do
    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: 'GB' } }

    connect_account = StripeConnectAccount.last
    assert_equal @user, connect_account.user
    assert_equal 'GB', connect_account.country_code
    assert_equal @stripe_account.id, connect_account.stripe_identifier
  end

  test '#create redirects to the link action' do
    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: 'GB' } }

    assert_redirected_to link_stripe_connect_account_path(@stripe_account.id)
  end

  test '#create re-renders account page with flash alert if validation fails' do
    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: '' } }

    assert_response :unprocessable_content
    assert_equal 'Stripe Connect account is invalid', flash[:alert]
  end

  test '#create does not create a Stripe::Account if validation fails' do
    Stripe::Account.expects(:create).never

    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: '' } }
  end

  test '#create does not create a StripeConnectAccount if validation fails' do
    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: '' } }

    assert_nil @user.reload.stripe_connect_account
  end

  test '#create redirects to account page if error creating Stripe account via API' do
    Stripe::Account.stubs(:create).raises(Stripe::StripeError.new)

    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: 'GB' } }

    assert_redirected_to account_path
    assert_equal 'Error creating Stripe Connect account', flash[:alert]
  end

  test '#create reports exception to Rollbar if error creating Stripe account via API' do
    stripe_error = Stripe::StripeError.new
    Stripe::Account.stubs(:create).raises(stripe_error)
    Rollbar.expects(:error).with(stripe_error)

    post stripe_connect_accounts_path, params: { stripe_connect_account: { country_code: 'GB' } }
  end
end

class StripeConnectAccountsControllerLinkTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, stripe_connect_enabled: true)
    log_in_as(@user)

    @stripe_account_id = 'acct-id'
    attributes = attributes_for(:stripe_connect_account, stripe_identifier: @stripe_account_id)
    @user.create_stripe_connect_account!(attributes)

    url = success_stripe_connect_account_url(@stripe_account_id)
    @stripe_account_link = stub('Stripe::AccountLink', url:)
    Stripe::AccountLink.stubs(:create).returns(@stripe_account_link)
  end

  test '#link creates a Stripe::AccountLink' do
    Stripe::AccountLink.expects(:create).with(
      {
        account: @stripe_account_id,
        refresh_url: link_stripe_connect_account_url(@stripe_account_id),
        return_url: success_stripe_connect_account_url(@stripe_account_id),
        type: 'account_onboarding'
      }
    ).returns(@stripe_account_link)

    get link_stripe_connect_account_path(@stripe_account_id)
  end

  test '#link redirects to Stripe::AccountLink#url' do
    get link_stripe_connect_account_path(@stripe_account_id)

    assert_redirected_to @stripe_account_link.url, allow_other_host: true
  end
end

class StripeConnectAccountsControllerSuccessTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, stripe_connect_enabled: true)
    log_in_as(@user)

    @stripe_account_id = 'acct-id'
    attributes = attributes_for(:stripe_connect_account, stripe_identifier: @stripe_account_id)
    @stripe_connect_account = @user.create_stripe_connect_account!(attributes)

    @stripe_account = stub(
      'Stripe::Account', {
        id: @stripe_account_id,
        details_submitted?: false,
        charges_enabled?: false,
        payouts_enabled?: false
      }
    )
  end

  test '#success updates StripeConnectAccount#details_submitted?' do
    @stripe_account.stubs(details_submitted?: true)
    Stripe::Account.stubs(:retrieve).with(@stripe_account_id).returns(@stripe_account)

    get success_stripe_connect_account_path(@stripe_account_id)

    assert @stripe_connect_account.reload.details_submitted?
  end

  test '#success updates StripeConnectAccount#charges_enabled?' do
    @stripe_account.stubs(charges_enabled?: true)
    Stripe::Account.stubs(:retrieve).with(@stripe_account_id).returns(@stripe_account)

    get success_stripe_connect_account_path(@stripe_account_id)

    assert @stripe_connect_account.reload.charges_enabled?
  end

  test '#success updates StripeConnectAccount#payouts_enabled?' do
    @stripe_account.stubs(payouts_enabled?: true)
    Stripe::Account.stubs(:retrieve).with(@stripe_account_id).returns(@stripe_account)

    get success_stripe_connect_account_path(@stripe_account_id)

    assert @stripe_connect_account.reload.payouts_enabled?
  end

  test '#success redirects to account page' do
    Stripe::Account.stubs(:retrieve).with(@stripe_account_id).returns(@stripe_account)

    get success_stripe_connect_account_path(@stripe_account_id)

    assert_redirected_to account_path
  end
end
