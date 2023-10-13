# frozen_string_literal: true

require 'application_system_test_case'

class InterestsTest < ApplicationSystemTestCase
  setup do
    @interest = build(:interest)
  end

  test 'visiting the index' do
    visit new_interest_url
    assert_selector 'h1', text: 'A new music platform'
  end

  test 'should create interest and send a confirmation email' do
    visit new_interest_url

    fill_in 'Email', with: @interest.email

    assert_emails 1 do
      click_button 'Submit'
    end

    assert_text "We've sent you an email"

    visit confirmation_url
    assert_text 'Thank you for registering your interest'
  end

  private

  def confirmation_url
    mail = ActionMailer::Base.deliveries.last
    mail.to_s[/http.*confirm_email/].gsub('http://example.com/', root_url)
  end
end
