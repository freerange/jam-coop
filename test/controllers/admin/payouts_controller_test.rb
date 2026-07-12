# frozen_string_literal: true

require 'test_helper'

module Admin
  class PayoutsControllerTest < ActionDispatch::IntegrationTest
    test '#index displays table of all Stripe payouts' do
      create(:stripe_payout, transaction_reference: 'payout-1')
      create(:stripe_payout, transaction_reference: 'payout-2')
      create(:payout, transaction_reference: 'non-stripe-payout')
      admin = create(:user, admin: true)
      log_in_as(admin)

      get admin_payouts_path

      assert_response :success
      assert_select 'table tbody' do
        assert_select 'tr', text: /payout-1/
        assert_select 'tr', text: /payout-2/
        assert_select 'tr', text: /non-stripe-payout/, count: 0
      end
    end

    test '#index redirects to home page if user is not an admin' do
      user = create(:user)
      log_in_as(user)

      get admin_payouts_path

      assert_redirected_to root_path
      assert_equal 'You are not authorized to perform this action.', flash[:alert]
    end

    test '#index redirects to login if user is not logged in' do
      get admin_payouts_path

      assert_redirected_to log_in_path
    end
  end
end
