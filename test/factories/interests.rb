# frozen_string_literal: true

FactoryBot.define do
  factory :interest do
    email { 'chris@example.com' }
    confirm_token { SecureRandom.urlsafe_base64.to_s }
  end
end
