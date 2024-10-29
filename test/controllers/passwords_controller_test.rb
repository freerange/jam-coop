# frozen_string_literal: true

require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = log_in_as(create(:user))
  end

  test 'should update password' do
    patch password_url,
          params: { current_password: 'Secret1*3*5*', password: 'Secret6*4*2*', password_confirmation: 'Secret6*4*2*' }
    assert_redirected_to account_path
  end

  test 'should not update password with wrong current password' do
    patch password_url,
          params: { current_password: 'SecretWrong1*3', password: 'Secret6*4*2*',
                    password_confirmation: 'Secret6*4*2*' }

    assert_redirected_to account_path
    assert_equal 'The current password you entered is incorrect', flash[:incorrect_password]
  end
end
