# frozen_string_literal: true

require 'test_helper'

class PayoutDetailsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    log_in_as(@user)
  end

  test '#create creates a new PayoutDetail and redirects to account_path' do
    assert_difference('PayoutDetail.count') do
      post payout_detail_path, params: { payout_detail: { name: 'Alice', country: 'country' } }
    end

    assert_redirected_to account_path
  end

  test '#create assigns the name in the param to the PayoutDetail' do
    post payout_detail_path, params: { payout_detail: { name: 'Alice', country: 'country' } }

    assert_equal 'Alice', PayoutDetail.last.name
  end

  test '#create associates the PayoutDetail with the current user' do
    post payout_detail_path, params: { payout_detail: { name: 'Alice', country: 'country' } }

    assert_equal @user, PayoutDetail.last.user
  end

  test '#update updates fields and redirects to account page' do
    create(:payout_detail, user: @user)

    patch payout_detail_path, params: { payout_detail: { name: 'Bob', country: 'country' } }

    assert_equal 'Bob', @user.reload.payout_detail.name
    assert_redirected_to account_path
  end

  test '#update 404s if user has no payout detail' do
    patch payout_detail_path, params: { payout_detail: { name: 'Bob', country: 'country' } }

    assert_response :not_found
  end
end

class PayoutDetailsControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#update' do
    patch payout_detail_path
    assert_redirected_to log_in_path
  end
end
