# frozen_string_literal: true

require 'test_helper'
require 'capybara/cuprite'

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1400, 1400], timeout: 10)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionMailer::TestHelper

  driven_by :cuprite

  def sign_in_as(user)
    visit sign_in_url
    fill_in :email, with: user.email
    fill_in :password, with: 'Secret1*3*5*'
    click_button 'Sign in'
    assert_current_path root_url
    user
  end

  def sign_out
    click_button 'avatar'
    click_button 'Log out'
  end
end
