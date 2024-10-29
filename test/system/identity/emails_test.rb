# frozen_string_literal: true

require 'application_system_test_case'

module Identity
  class EmailsTest < ApplicationSystemTestCase
    setup do
      @user = log_in_as(create(:user))
    end

    test 'when I update my email address I should be prompted to verify it' do
      visit edit_identity_email_path

      fill_in 'New email', with: 'new_email@example.com'
      fill_in 'Current password', with: 'Secret1*3*5*'
      click_on 'Save changes'

      assert_text 'Your email has been changed'

      visit edit_identity_email_path
      assert_text 'We sent a verification email to the address below'

      click_on 'Re-send verification email'
      assert_text 'We sent a verification email to your email address'
    end

    test 'updating my email address fails if my current password is wrong' do
      visit edit_identity_email_path

      fill_in 'New email', with: 'new_email@example.com'
      fill_in 'Current password', with: 'wrongpassword'
      click_on 'Save changes'

      assert_text 'The password you entered is incorrect'
      refute_text 'We sent a verification email to the address below'
    end

    test 'updating my email address fails if I use an existing email' do
      existing_user = create(:user)

      visit edit_identity_email_path

      fill_in 'New email', with: existing_user.email
      fill_in 'Current password', with: 'Secret1*3*5*'
      click_on 'Save changes'

      assert_text 'Email has already been taken'
      refute_text 'We sent a verification email to the address below'
    end
  end
end
