# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = create(:user)
  end

  test 'password_reset' do
    mail = UserMailer.with(user: @user).password_reset
    assert_equal 'Reset your password', mail.subject
    assert_equal [@user.email], mail.to
  end

  test 'does not send password reset if user has sending suppressed' do
    @user.update!(sending_suppressed_at: Time.current)
    UserMailer.with(user: @user).password_reset
    assert_emails 0
  end

  test 'email_verification' do
    mail = UserMailer.with(user: @user).email_verification
    assert_equal 'Verify your email', mail.subject
    assert_equal [@user.email], mail.to
  end

  test 'does not send email verification if user has sending suppressed' do
    @user.update!(sending_suppressed_at: Time.current)
    UserMailer.with(user: @user).email_verification
    assert_emails 0
  end

  test 'invitation_instructions' do
    mail = UserMailer.with(user: @user).invitation_instructions
    assert_equal 'You have been invited to jam.coop', mail.subject
    assert_equal [@user.email], mail.to
  end
end
