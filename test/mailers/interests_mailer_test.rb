# frozen_string_literal: true

require 'test_helper'

class InterestsMailerTest < ActionMailer::TestCase
  test 'confirm' do
    interest = Interest.create(email: 'chris@example.com')
    mail = InterestsMailer.confirm(interest)
    assert_equal 'Confirm your email address', mail.subject
    assert_equal ['chris@example.com'], mail.to
    assert_equal ['contact@jam.coop'], mail.from
    assert mail.track_opens
    assert_equal 'outbound', mail.message_stream
    assert_match 'Thank you', mail.body.encoded
  end
end
