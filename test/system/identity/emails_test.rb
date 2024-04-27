# frozen_string_literal: true

require 'application_system_test_case'

module Identity
  class EmailsTest < ApplicationSystemTestCase
    setup do
      @user = log_in_as(create(:user))
    end

    test 'updating the email' do
      click_on 'avatar'
      click_link 'My account'
      click_link 'Change email address'

      fill_in 'New email', with: 'new_email@hey.com'
      fill_in 'Current password', with: 'Secret1*3*5*'
      click_on 'Save changes'

      assert_text 'Your email has been changed'
    end

    test 'sending a verification email' do
      @user.update! verified: false

      click_on 'avatar'
      click_link 'My account'
      click_link 'Change email address'
      click_on 'Re-send verification email'

      assert_text 'We sent a verification email to your email address'
    end
  end
end
