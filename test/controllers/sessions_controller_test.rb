# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, admin: true)
  end

  test 'should get new' do
    get log_in_url
    assert_response :success
  end

  test 'should sign in' do
    post log_in_url, params: { email: @user.email, password: 'Secret1*3*5*' }
    assert_redirected_to root_url

    get a_url_that_requires_authentication
    assert_response :success
  end

  test 'should not sign in with wrong credentials' do
    post log_in_url, params: { email: @user.email, password: 'SecretWrong1*3' }
    assert_redirected_to log_in_url(email_hint: @user.email)
    assert_equal 'That email or password is incorrect', flash[:alert]

    get a_url_that_requires_authentication
    assert_redirected_to log_in_url
  end

  test 'should sign out' do
    log_in_as @user

    delete session_url(@user.sessions.last)
    assert_redirected_to sessions_url

    follow_redirect!
    assert_redirected_to log_in_url
  end

  private

  def a_url_that_requires_authentication
    account_url
  end
end
