# frozen_string_literal: true

require 'test_helper'

class BroadcastMailerTest < ActionMailer::TestCase
  test 'build test email' do
    user = build(:user, email: 'ann@example.com')

    mail = BroadcastMailer.test(user)

    assert_equal 'Testing BroadcastMailer', mail.subject
    assert_equal ['ann@example.com'], mail.to
    assert_equal ['contact@jam.coop'], mail.from
    assert_match 'Testing, testing, 123 - is this thing on?', mail.body.encoded
    assert_equal 'true', mail.message.track_opens
    assert_equal 'broadcast', mail.message.message_stream
  end

  test 'send test email if user does not have sending suppressed' do
    user = create(:user)

    BroadcastMailer.test(user).deliver_now!

    assert_emails 1
  end

  test 'do not send test email if user has sending suppressed' do
    user = create(:user)
    create(:hard_bounce, user:)

    BroadcastMailer.test(user).deliver_now!

    assert_emails 0
  end
end
