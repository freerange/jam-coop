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

  test 'should create interest' do
    visit root_url

    fill_in 'Email', with: @interest.email
    click_on 'Create Interest'

    assert_text 'Thank you'
  end
end
