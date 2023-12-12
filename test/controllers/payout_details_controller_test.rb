# frozen_string_literal: true

require 'test_helper'

class PayoutDetailsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    log_in_as(@user)
  end

  test '#new' do
    get new_payout_detail_url
    assert_response :success
  end

  test '#create creates a new PayoutDetail and redirects to account_url' do
    assert_difference('PayoutDetail.count') do
      post payout_detail_url, params: { payout_detail: { name: 'Alice' } }
    end

    assert_redirected_to account_url
  end

  test '#create assigns the name in the param to the PayoutDetail' do
    post payout_detail_url, params: { payout_detail: { name: 'Alice' } }

    assert_equal 'Alice', PayoutDetail.last.name
  end

  test '#create associates the PayoutDetail with the current user' do
    post payout_detail_url, params: { payout_detail: { name: 'Alice' } }

    assert_equal @user, PayoutDetail.last.user
  end
end

class PayoutDetailsControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#new' do
    get new_payout_detail_url
    assert_redirected_to log_in_url
  end
end
