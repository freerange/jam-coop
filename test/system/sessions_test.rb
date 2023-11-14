# frozen_string_literal: true

require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
  end

  test 'signing in' do
    visit sign_in_url
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'Secret1*3*5*'
    click_button 'Sign in'

    assert_text 'Signed in successfully'
  end

  test 'signing out' do
    sign_in_as @user

    click_button 'avatar'
    click_button 'Log out'
    assert_text 'That session has been logged out'
  end
end
