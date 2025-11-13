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

  test '#update_newsletter_preference can opt out of newsletter' do
    assert @user.opt_in_to_newsletter

    patch users_newsletter_preference_path, params: { user: { opt_in_to_newsletter: false } }

    assert_redirected_to account_path
    assert_equal 'Newsletter preference updated successfully.', flash[:notice]
    assert_not @user.reload.opt_in_to_newsletter
  end
end

class UserControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#show' do
    get account_path
    assert_redirected_to log_in_path
  end
end
