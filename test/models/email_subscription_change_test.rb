# frozen_string_literal: true

require 'test_helper'

class EmailSubscriptionChangeTest < ActiveSupport::TestCase
  test 'factory is valid' do
    change = build(:email_subscription_change)
    assert change.valid?
  end

  test 'is invalid if message_id is blank' do
    change = build(:email_subscription_change, message_id: nil)
    assert_not change.valid?
    assert_includes change.errors[:message_id], "can't be blank"
  end

  test 'is invalid if origin is blank' do
    change = build(:email_subscription_change, origin: nil)
    assert_not change.valid?
    assert_includes change.errors[:origin], "can't be blank"
  end

  test 'is invalid if suppression_reason is blank when suppress_sending is true' do
    change = build(:email_subscription_change, suppression_reason: nil, suppress_sending: true)
    assert_not change.valid?
    assert_includes change.errors[:suppression_reason], "can't be blank"
  end

  test 'is valid if suppression_reason is blank when suppress_sending is false' do
    change = build(:email_subscription_change, suppression_reason: nil, suppress_sending: false)
    assert change.valid?
  end

  test 'is invalid if changed_at is blank' do
    change = build(:email_subscription_change, changed_at: nil)
    assert_not change.valid?
    assert_includes change.errors[:changed_at], "can't be blank"
  end

  test 'do not suppress sending by default' do
    change = EmailSubscriptionChange.new
    assert_not change.suppress_sending?
  end
end
