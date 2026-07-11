# frozen_string_literal: true

require 'test_helper'

class PayoutsControllerTest < ActionDispatch::IntegrationTest
  test '#index displays table of Stripe payouts belonging to user' do
    stripe_connect_account = create(:stripe_connect_account, charges_enabled: true)
    payout = create(:stripe_payout, transaction_reference: 'my-payout')
    create(:stripe_payout, transaction_reference: 'another-payout')
    create(:payout, transaction_reference: 'non-stripe-payout')
    user = create(:user, stripe_connect_account:, payouts: [payout])
    log_in_as(user)

    get payouts_path

    assert_response :success
    assert_select 'table tbody' do
      assert_select 'tr', text: /my-payout/
      assert_select 'tr', text: /another-payout/, count: 0
      assert_select 'tr', text: /non-stripe-payout/, count: 0
    end
  end

  test '#index redirects to login if no user logged in' do
    get payouts_path

    assert_redirected_to log_in_path
  end
end
