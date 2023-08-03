# frozen_string_literal: true

require 'test_helper'

class InterestsMailerTest < ActionMailer::TestCase
  test 'confirm' do
    interest = Interest.create(email: 'chris@example.com')
    mail = InterestsMailer.confirm(interest)
    assert_equal 'Confirm your email address', mail.subject
    assert_equal ['chris@example.com'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Thank you', mail.body.encoded
  end
end
