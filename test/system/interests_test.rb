# frozen_string_literal: true

require 'application_system_test_case'

class InterestsTest < ApplicationSystemTestCase
  setup do
    @interest = Interest.new(email: 'chris@example.com')
  end

  test 'visiting the index' do
    visit root_url
    assert_selector 'h1', text: 'New interest'
  end

  test 'should create interest and send a confirmation email' do
    visit root_url

    fill_in 'Email', with: @interest.email

    assert_emails 1 do
      click_on 'Create Interest'
    end

    assert_text 'Thank you'
  end
end
