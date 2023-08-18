# frozen_string_literal: true

require 'test_helper'

module Identity
  class EmailsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = sign_in_as(users(:lazaro_nixon))
    end

    test 'should get edit' do
      get edit_identity_email_url
      assert_response :success
    end

    test 'should update email' do
      patch identity_email_url, params: { email: 'new_email@hey.com', current_password: 'Secret1*3*5*' }
      assert_redirected_to root_url
    end

    test 'should not update email with wrong current password' do
      patch identity_email_url, params: { email: 'new_email@hey.com', current_password: 'SecretWrong1*3' }

      assert_redirected_to edit_identity_email_url
      assert_equal 'The password you entered is incorrect', flash[:alert]
    end
  end
end
