# frozen_string_literal: true

require 'test_helper'

class BroadcastMailerTest < ActionMailer::TestCase
  test 'build newsletter email' do
    user = build(:user, email: 'ann@example.com')
    newsletter = build(:newsletter, title: 'Latest news')

    mail = BroadcastMailer.with(recipient: user, newsletter:).newsletter

    assert_match 'jam.coop - Latest news', mail.subject
    assert_equal ['ann@example.com'], mail.to
    assert_equal ['contact@jam.coop'], mail.from
    assert_equal 'true', mail.message.track_opens
    assert_equal 'broadcast', mail.message.message_stream
  end

  test 'HTML newsletter renders the body markdown' do
    user = build(:user)
    newsletter = build(:newsletter, body: '## Hello')

    mail = BroadcastMailer.with(recipient: user, newsletter:).newsletter

    assert_match '<h2>Hello</h2>', mail.body.encoded
  end

  test 'Plain text newsletter includes the raw body markdown' do
    user = build(:user)
    newsletter = build(:newsletter, body: '## Hello')

    mail = BroadcastMailer.with(recipient: user, newsletter:).newsletter

    assert_match '## Hello', mail.body.encoded
  end

  test 'do not send newsletter email if recipient has sending suppressed' do
    user = create(:user, sending_suppressed_at: Time.current)
    interest = create(:interest, sending_suppressed_at: Time.current)
    newsletter = create(:newsletter)

    BroadcastMailer.with(recipient: user, newsletter:).newsletter.deliver_now
    BroadcastMailer.with(recipient: interest, newsletter:).newsletter.deliver_now

    assert_emails 0
  end
end
