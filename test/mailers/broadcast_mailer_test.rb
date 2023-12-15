# frozen_string_literal: true

require 'test_helper'

class BroadcastMailerTest < ActionMailer::TestCase
  test 'build newsletter email' do
    user = build(:user, email: 'ann@example.com')

    mail = BroadcastMailer.newsletter(user)

    assert_match 'jam.coop - Newsletter', mail.subject
    assert_equal ['ann@example.com'], mail.to
    assert_equal ['contact@jam.coop'], mail.from
    assert_match 'Hello', mail.body.encoded
    assert_equal 'true', mail.message.track_opens
    assert_equal 'broadcast', mail.message.message_stream
  end

  test 'do not send newsletter email if user has sending suppressed' do
    user = create(:user, sending_suppressed_at: Time.current)

    BroadcastMailer.newsletter(user).deliver_now!

    assert_emails 0
  end
end
