# frozen_string_literal: true

FactoryBot.define do
  factory :email_subscription_change do
    user
    message_id { SecureRandom.uuid }
    origin { 'Recipient' }
    suppress_sending { true }
    suppression_reason { 'Unknown' }
    changed_at { Time.current }
  end

  factory :hard_bounce, parent: :email_subscription_change do
    suppression_reason { 'HardBounce' }
  end

  factory :manual_suppression, parent: :email_subscription_change do
    suppression_reason { 'ManualSuppression' }
  end

  factory :manual_reactivation, parent: :email_subscription_change do
    suppress_sending { false }
    suppression_reason { nil }
  end
end
