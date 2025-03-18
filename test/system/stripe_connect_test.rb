# frozen_string_literal: true

require 'application_system_test_case'

class StripeConnectTest < ApplicationSystemTestCase
  test 'enabling Stripe Connect on my account' do
    stub_stripe_connect_user_flow

    log_in_as(artist_user)
    visit account_path

    click_on 'Setup Stripe Connect'

    assert_equal account_path, current_path
    assert_text stripe_account_id
    assert_text 'Charges enabled'
  end

  private

  def stripe_account_id
    'acct_id'
  end

  def stub_stripe_connect_user_flow
    Stripe::Account.stubs(:create).returns(
      stub('Stripe::Account', id: stripe_account_id)
    )
    Stripe::AccountLink.stubs(:create).with(
      has_entry(account: stripe_account_id)
    ).returns(
      stub('Stripe::AccountLink', url: success_stripe_connect_account_url(stripe_account_id))
    )
    Stripe::Account.stubs(:retrieve).with(stripe_account_id).returns(
      stub('Stripe::Account', details_submitted?: true, charges_enabled?: true)
    )
  end

  def artist_user
    @artist_user ||= create(:user)
  end
end
