# frozen_string_literal: true

require 'test_helper'

module Identity
  class EmailVerificationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = log_in_as(create(:user))
      @user.update! verified: false
    end

    test 'should send a verification email' do
      assert_enqueued_email_with UserMailer, :email_verification, params: { user: @user } do
        post identity_email_verification_path
      end

      assert_redirected_to root_path
    end

    test 'should verify email' do
      sid = @user.email_verification_tokens.create.signed_id(expires_in: 2.days)

      get identity_email_verification_path(sid:, email: @user.email)
      assert_redirected_to root_path
    end

    test 'should not verify email with expired token' do
      sid_exp = @user.email_verification_tokens.create.signed_id(expires_in: 0.minutes)

      get identity_email_verification_path(sid: sid_exp, email: @user.email)

      assert_redirected_to root_path
      assert_equal 'That email verification link is invalid', flash[:alert]
    end
  end
end
