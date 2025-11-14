# frozen_string_literal: true

require 'application_system_test_case'

class EmailPreferencesTest < ApplicationSystemTestCase
  setup do
    @user = log_in_as(create(:user))
  end

  test 'updating newsletter preference' do
    visit account_path

    within(email_preferences_section) do
      assert_checked_field 'Newsletter'
      uncheck 'Newsletter'
      click_on 'Save changes'
    end

    assert_text 'Newsletter preference updated successfully'
    assert_no_checked_field 'Newsletter'
  end

  private

  def email_preferences_section
    find('h2', text: 'Email preferences').ancestor('.sidebar-section')
  end
end
