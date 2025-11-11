# frozen_string_literal: true

require 'test_helper'
require 'capybara/cuprite'
require 'support/screenshot_helper_with_multiple_sessions'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionMailer::TestHelper

  headless = ActiveRecord::Type::Boolean.new.cast(ENV.fetch('HEADLESS', true))
  driven_by :cuprite, options: { headless: }

  def setup
    stub_successful_cloudflare_turnstile_request
  end

  def log_in_as(user)
    visit log_in_url
    fill_in :email, with: user.email
    fill_in :password, with: 'Secret1*3*5*'
    click_on 'Log in'
    assert_current_path root_url
    user
  end

  def sign_out
    click_on 'avatar'
    click_on 'Log out'
  end

  private

  def stub_successful_cloudflare_turnstile_request
    stub_request(:post, 'https://challenges.cloudflare.com/turnstile/v0/siteverify')
      .to_return(status: 200, body: { success: true }.to_json)
  end

  def stub_stripe_checkout_session
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)
  end
end
