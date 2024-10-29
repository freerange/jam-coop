# frozen_string_literal: true

require 'test_helper'

module Identity
  class EmailsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = log_in_as(create(:user))
    end

    test 'should update email' do
      patch identity_email_url, params: { email: 'new_email@hey.com', current_password: 'Secret1*3*5*' }
      assert_redirected_to account_path
    end

    test 'should not update email with wrong current password' do
      patch identity_email_url, params: { email: 'new_email@hey.com', current_password: 'SecretWrong1*3' }

      assert_redirected_to account_path
      assert_equal 'The password you entered is incorrect', flash[:emails_update_password_incorrect]
    end
  end
end
