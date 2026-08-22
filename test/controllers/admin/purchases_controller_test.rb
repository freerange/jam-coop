# frozen_string_literal: true

require 'test_helper'

module Admin
  class PurchasesControllerTest < ActionDispatch::IntegrationTest
    test '#index displays table of all completed purchases' do
      create(:purchase)
      create(:purchase)
      create(:purchase)
      admin = create(:user, admin: true)
      log_in_as(admin)

      get admin_purchases_path

      assert_response :success
      assert_select 'table tbody tr', count: 3
    end

    test '#index redirects to home page if user is not an admin' do
      user = create(:user)
      log_in_as(user)

      get admin_purchases_path

      assert_not_authorized
    end

    test '#index redirects to login if user is not logged in' do
      get admin_purchases_path

      assert_redirected_to log_in_path
    end
  end
end
