# frozen_string_literal: true

require 'application_system_test_case'

class PayoutDetailsTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    log_in_as(@user)
  end

  test 'adding payout details' do
    visit account_url
    click_link 'Add payout details'
    fill_in 'Name', with: 'John Lennon'
    click_button 'Save'

    assert_equal 'John Lennon', @user.payout_detail.name
  end
end
