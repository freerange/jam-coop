# frozen_string_literal: true

require 'test_helper'

class NewsletterTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test 'factory is valid' do
    assert build(:newsletter).valid?
  end

  test '#send delivers to Users who have opted in, verified and are not suppressed' do
    newsletter = create(:newsletter)
    create(:user, verified: true, opt_in_to_newsletter: true, sending_suppressed_at: nil)

    assert_enqueued_emails 1 do
      newsletter.send_as_email
    end
  end

  test '#send does not deliver to Users who have opted out' do
    newsletter = create(:newsletter)
    create(:user, verified: true, opt_in_to_newsletter: false, sending_suppressed_at: nil)

    assert_no_enqueued_emails do
      newsletter.send_as_email
    end
  end

  test '#send does not deliver to Users who are suppressed' do
    newsletter = create(:newsletter)
    create(:user, verified: true, opt_in_to_newsletter: true, sending_suppressed_at: Time.zone.now)

    assert_no_enqueued_emails do
      newsletter.send_as_email
    end
  end

  test '#send does not deliver to Users who are not verified' do
    newsletter = create(:newsletter)
    create(:user, verified: false, opt_in_to_newsletter: true, sending_suppressed_at: nil)

    assert_no_enqueued_emails do
      newsletter.send_as_email
    end
  end

  test '#send delivers to Interests who have confirmed and are not suppressed' do
    newsletter = create(:newsletter)
    create(:interest, email_confirmed: true, sending_suppressed_at: nil)

    assert_enqueued_emails 1 do
      newsletter.send_as_email
    end
  end

  test '#send does not deliver to Interests who are not confirmed' do
    newsletter = create(:newsletter)
    create(:interest, email_confirmed: false, sending_suppressed_at: nil)

    assert_no_enqueued_emails do
      newsletter.send_as_email
    end
  end

  test '#send does not deliver to Interests who are suppressed' do
    newsletter = create(:newsletter)
    create(:interest, email_confirmed: true, sending_suppressed_at: Time.zone.now)

    assert_no_enqueued_emails do
      newsletter.send_as_email
    end
  end
end
