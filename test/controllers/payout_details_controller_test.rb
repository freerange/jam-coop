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

  test '#update updates fields and redirects to account page' do
    create(:payout_detail, user: @user)

    patch payout_detail_url, params: { payout_detail: { name: 'Bob' } }

    assert_equal 'Bob', @user.reload.payout_detail.name
    assert_redirected_to account_url
  end

  test '#update 404s if user has no payout detail' do
    patch payout_detail_url, params: { payout_detail: { name: 'Bob' } }

    assert_response :not_found
  end

  test '#edit' do
    create(:payout_detail, user: @user)

    get edit_payout_detail_url
    assert_response :success
  end

  test '#edit 404s if user has no payout detail' do
    get edit_payout_detail_url
    assert_response :not_found
  end
end

class PayoutDetailsControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#new' do
    get new_payout_detail_url
    assert_redirected_to log_in_url
  end

  test '#edit' do
    get edit_payout_detail_url
    assert_redirected_to log_in_url
  end

  test '#update' do
    patch payout_detail_url
    assert_redirected_to log_in_url
  end
end
