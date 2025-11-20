# frozen_string_literal: true

require 'application_system_test_case'

class SigningUpTest < ApplicationSystemTestCase
  test 'signing up' do
    visit root_path
    click_on 'sign up'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'Secret1*3*5*'
    fill_in 'Password confirmation', with: 'Secret1*3*5*'
    perform_enqueued_jobs do
      click_on 'Sign up'
    end

    assert_text 'Welcome! You have signed up successfully'

    visit verify_email_url
    assert_text 'Thank you for verifying your email address'
  end
end
