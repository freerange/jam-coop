# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, admin: true)
  end

  test 'should get new' do
    get log_in_path
    assert_response :success
  end

  test 'should sign in' do
    post log_in_path, params: { email: @user.email, password: 'Secret1*3*5*' }
    assert_redirected_to root_path

    get a_path_that_requires_authentication
    assert_response :success
  end

  test 'should not sign in with wrong credentials' do
    post log_in_path, params: { email: @user.email, password: 'SecretWrong1*3' }
    assert_redirected_to log_in_path(email_hint: @user.email)
    assert_equal 'That email or password is incorrect', flash[:alert]

    get a_path_that_requires_authentication
    assert_redirected_to log_in_path
  end

  test 'should sign out' do
    log_in_as @user

    delete session_path(@user.sessions.last)
    assert_redirected_to sessions_path

    follow_redirect!
    assert_redirected_to log_in_path
  end

  private

  def a_path_that_requires_authentication
    account_path
  end
end
