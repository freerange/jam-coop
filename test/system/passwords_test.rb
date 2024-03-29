# frozen_string_literal: true

require 'application_system_test_case'

class PasswordsTest < ApplicationSystemTestCase
  setup do
    @user = log_in_as(create(:user))
  end

  test 'updating the password' do
    click_button 'avatar'
    click_link 'My account'
    click_link 'Change password'

    fill_in 'Current password', with: 'Secret1*3*5*'
    fill_in 'New password', with: 'Secret6*4*2*'
    fill_in 'Confirm new password', with: 'Secret6*4*2*'
    click_button 'Save changes'

    assert_text 'Your password has been changed'
  end
end
