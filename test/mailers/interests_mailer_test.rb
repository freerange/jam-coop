# frozen_string_literal: true

require 'test_helper'

class InterestsMailerTest < ActionMailer::TestCase
  test 'confirm' do
    interest = create(:interest)
    mail = InterestsMailer.confirm(interest)
    assert_equal 'Confirm your email address', mail.subject
    assert_equal ['chris@example.com'], mail.to
    assert_equal ['contact@jam.coop'], mail.from
    assert mail.track_opens
    assert_equal 'outbound', mail.message_stream
    assert_match 'Thank you', mail.body.encoded
  end

  test 'do not send test email if user has sending suppressed' do
    interest = create(:interest, sending_suppressed_at: Time.current)
    InterestsMailer.confirm(interest)
    assert_emails 0
  end
end
