# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @album = create(:album)
    log_in_as(create(:user, admin: true))
  end

  test '#new should render a registration form' do
    get sign_up_url

    assert_response :success
    assert_select "input[type='email']"
    assert_select "input[type='password']"
    assert_select "input[type='password']", id: 'password-confirmation'
    assert_select "button[type='submit']"
  end

  test '#create creates a new user' do
    assert_difference('User.count') do
      post sign_up_url, params: {
        email: 'user@example.com',
        password: 'Secret1*3*5*',
        password_confirmation: 'Secret1*3*5*'
      }
    end
  end

  test '#create sets a session token cookie' do
    post sign_up_url, params: {
      email: 'user@example.com',
      password: 'Secret1*3*5*',
      password_confirmation: 'Secret1*3*5*'
    }

    assert cookies[:session_token]
  end

  test '#create redirects to the home page' do
    post sign_up_url,
         params: { email: 'user@example.com', password: 'Secret1*3*5*', password_confirmation: 'Secret1*3*5*' }

    assert_redirected_to root_path
  end

  test '#create sends an email verification email' do
    assert_enqueued_emails 1 do
      post sign_up_url,
           params: { email: 'user@example.com', password: 'Secret1*3*5*', password_confirmation: 'Secret1*3*5*' }
    end
  end

  test '#create shows an error if data is unprocessable' do
    post sign_up_url, params: { email: '', password: '', password_confirmation: '' }

    assert_response :unprocessable_entity
    assert_select 'h2', text: /errors prohibited this user from being saved/
  end
end
