# frozen_string_literal: true

require 'application_system_test_case'

class PasswordsTest < ApplicationSystemTestCase
  setup do
    @user = log_in_as(create(:user))
  end

  test 'updating the password' do
    visit account_path

    within(password_section) do
      fill_in 'Current password', with: 'Secret1*3*5*'
      fill_in 'New password', with: 'Secret6*4*2*'
      fill_in 'Confirm new password', with: 'Secret6*4*2*'
      click_on 'Save changes'
    end

    assert_text 'Your password has been changed'
    assert_current_path account_path
  end

  test 'when password is too short' do
    visit account_path

    within(password_section) do
      fill_in 'Current password', with: 'Secret1*3*5*'
      fill_in 'New password', with: 'short'
      fill_in 'Confirm new password', with: 'short'
      click_on 'Save changes'
    end

    assert_text 'Password is too short'
    assert_current_path account_path
  end

  private

  def password_section
    find('h2', text: 'Password').ancestor('.sidebar-section')
  end
end
