# frozen_string_literal: true

require 'test_helper'

class UsersControllerTestSignedIn < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    log_in_as(@user)
  end

  test '#show' do
    get account_url
    assert_response :success
  end

  test '#show has a link to change password' do
    get account_url
    assert_select 'a', href: edit_password_path
  end

  test '#show has a link to change email address' do
    get account_url
    assert_select 'a', href: edit_identity_email_path
  end
end

class UserControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#show' do
    get account_url
    assert_redirected_to log_in_path
  end
end
