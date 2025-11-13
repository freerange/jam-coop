# frozen_string_literal: true

require 'application_system_test_case'

class PayoutDetailsTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    log_in_as(@user)
  end

  test 'adding payout details' do
    visit account_path

    within(payout_details_section) do
      fill_in 'Name', with: 'John Lennon'
      select '🇬🇧 United Kingdom (GBP)', from: 'Country / Region'
      click_on 'Add payout details'
    end

    assert_text 'Payout details added'
    assert_equal 'John Lennon', @user.payout_detail.name
    assert_equal 'united_kingdom', @user.payout_detail.country
  end

  test 'updating payout details' do
    create(:payout_detail, user: @user)

    visit account_path

    within(payout_details_section) do
      fill_in 'Name', with: 'John Smith'
      select '🇬🇧 United Kingdom (GBP)', from: 'Country / Region'
      click_on 'Save changes'
    end

    assert_text 'Payout details updated'
  end

  private

  def payout_details_section
    find('h2', text: 'Payout details').ancestor('.sidebar-section')
  end
end
