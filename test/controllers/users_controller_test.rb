# frozen_string_literal: true

require 'test_helper'

class UsersControllerTestSignedIn < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    log_in_as(@user)
  end

  test '#show' do
    get account_path
    assert_response :success
  end
end

class UserControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#show' do
    get account_path
    assert_redirected_to log_in_path
  end
end
