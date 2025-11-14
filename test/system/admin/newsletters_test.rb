# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class NewslettersTest < ApplicationSystemTestCase
    setup do
      @admin = create(:user, admin: true)
    end

    test 'creating a newsletter' do
      log_in_as(@admin)
      visit new_admin_newsletter_path

      fill_in 'Title', with: 'New Newsletter Title'
      fill_in 'Body', with: 'This is the newsletter body content'

      click_on 'Save'

      assert_text 'Newsletter was successfully created.'
      assert_field 'Title', with: 'New Newsletter Title'
    end

    test 'editing a newsletter' do
      newsletter = create(:newsletter, title: 'Original Title', body: 'Original body')
      log_in_as(@admin)

      visit edit_admin_newsletter_path(newsletter)

      assert_field 'Title', with: 'Original Title'
      assert_field 'Body', with: 'Original body'

      fill_in 'Title', with: 'Updated Title'
      fill_in 'Body', with: 'Updated body'

      click_on 'Save'

      assert_text 'Newsletter was successfully updated.'
      assert_field 'Title', with: 'Updated Title'
      assert_field 'Body', with: 'Updated body'
    end
  end
end
