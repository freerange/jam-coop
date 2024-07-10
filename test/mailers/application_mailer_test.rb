# frozen_string_literal: true

require 'test_helper'

class TestMailer < ApplicationMailer
  def application_mailer_email
    mail to: 'alice@example.com', subject: 'A test email', body: 'A test email'
  end
end

class ApplicationMailerTest < ActionMailer::TestCase
  test 'an application_mailer_email from has the name and email address' do
    mail = TestMailer.application_mailer_email
    assert_equal 'Jam <contact@jam.coop>', mail.message.from_address.to_s
  end
end
