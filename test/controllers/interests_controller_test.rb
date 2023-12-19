# frozen_string_literal: true

require 'test_helper'

class InterestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interest = build(:interest)
  end

  test '#new should get new' do
    get new_interest_url
    assert_response :success
  end

  test '#create should create interest' do
    assert_difference('Interest.count') do
      post interests_url, params: { interest: { email: @interest.email } }
    end

    assert_redirected_to thankyou_url
  end

  test '#create should find an existing record if one exists' do
    @interest.save

    assert_no_difference('Interest.count') do
      post interests_url, params: { interest: { email: @interest.email } }
    end

    assert_redirected_to thankyou_url
  end

  test '#create should send a confirmation email' do
    @interest.save

    assert_enqueued_emails 1 do
      post interests_url, params: { interest: { email: @interest.email } }
    end
  end

  test '#confirm_email should active an email address' do
    @interest.save

    assert_changes -> { @interest.reload.email_confirmed } do
      get confirm_email_interest_url(@interest.confirm_token)
    end

    assert_redirected_to confirmation_url
  end

  test '#confirm_email should handle unknown confirmation tokens' do
    get confirm_email_interest_url('invalid-token')

    assert_redirected_to root_url
  end
end
