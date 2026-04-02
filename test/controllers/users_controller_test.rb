# frozen_string_literal: true

require 'test_helper'

class UsersControllerTestSignedIn < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    log_in_as(@user)
  end

  test '#show' do
    get account_path
    assert_response :success
  end

  test '#show does not display button to setup Stripe Connect if Stripe Connect is disabled for user' do
    @user.update!(stripe_connect_enabled: false)
    get account_path

    assert_select 'input[type=submit][value=?]', 'Connect Stripe', count: 0
  end

  test '#show displays button to setup Stripe Connect if Stripe Connect is enabled for user' do
    @user.update!(stripe_connect_enabled: true)

    get account_path

    assert_select 'input[type=submit][value=?]', 'Connect Stripe'
  end

  test '#show displays status if user has submitted details for Stripe Connect account' do
    @user.update!(stripe_connect_enabled: true)
    attributes = attributes_for(:stripe_connect_account, details_submitted: true)
    @user.create_stripe_connect_account(attributes)

    get account_path

    assert_select stripe_connect_section_selector do
      assert_select(
        'p',
        "You've started connecting a Stripe account, but it's not yet ready to receive payments. " \
        'Edit the account to address any outstanding issues.'
      )
    end
  end

  test '#show displays status if Stripe Connect account has charges enabled' do
    @user.update!(stripe_connect_enabled: true)
    attributes = attributes_for(:stripe_connect_account, charges_enabled: true)
    @user.create_stripe_connect_account(attributes)

    get account_path

    assert_select stripe_connect_section_selector do
      assert_select(
        'p',
        'Your Stripe account is connected. We will automatically make payments to this account on every purchase.'
      )
    end
  end

  test '#update_newsletter_preference can opt out of newsletter' do
    assert @user.opt_in_to_newsletter

    patch users_newsletter_preference_path, params: { user: { opt_in_to_newsletter: false } }

    assert_redirected_to account_path
    assert_equal 'Newsletter preference updated successfully.', flash[:notice]
    assert_not @user.reload.opt_in_to_newsletter
  end

  private

  def stripe_connect_section_selector
    "section.sidebar-section:has(h2:contains('Stripe'))"
  end
end

class UserControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#show' do
    get account_path
    assert_redirected_to log_in_path
  end
end
