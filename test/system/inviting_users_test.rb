# frozen_string_literal: true

require 'application_system_test_case'

class InvitingUsersTest < ApplicationSystemTestCase
  setup do
    sign_in_as(create(:user))
  end

  test 'should invite a user and allow them to reset their password' do
    visit new_invitation_url
    fill_in 'Email', with: 'artist@example.com'

    assert_emails 1 do
      click_button 'Invite'
    end

    assert_text 'An invitation email has been sent to artist@example.com'
    click_button 'Log out'

    visit accept_invitation_url

    fill_in 'New password', with: 'new-password'
    fill_in 'Confirm new password', with: 'new-password'
    click_button 'Save changes'

    assert_text 'Your password was reset successfully. Please sign in'
  end

  private

  def accept_invitation_url
    mail = ActionMailer::Base.deliveries.last
    password_reset_url = /"(?<url>http.*password_reset.*)"/.match(mail.to_s).named_captures['url']
    password_reset_url.gsub('http://example.com/', root_url)
  end
end