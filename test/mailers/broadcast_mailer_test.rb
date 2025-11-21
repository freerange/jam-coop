# frozen_string_literal: true

require 'test_helper'

class BroadcastMailerTest < ActionMailer::TestCase
  test 'build newsletter email' do
    user = build(:user, email: 'ann@example.com')
    newsletter = build(:newsletter, title: 'Latest news')

    mail = BroadcastMailer.newsletter(user, newsletter)

    assert_match 'jam.coop - Latest news', mail.subject
    assert_equal ['ann@example.com'], mail.to
    assert_equal ['contact@jam.coop'], mail.from
    assert_match 'Hey folks', mail.body.encoded
    assert_equal 'true', mail.message.track_opens
    assert_equal 'broadcast', mail.message.message_stream
  end

  test 'do not send newsletter email if recipient has sending suppressed' do
    user = create(:user, sending_suppressed_at: Time.current)
    interest = create(:interest, sending_suppressed_at: Time.current)
    newsletter = create(:newsletter)

    BroadcastMailer.newsletter(user, newsletter).deliver_now!
    BroadcastMailer.newsletter(interest, newsletter).deliver_now!

    assert_emails 0
  end
end
