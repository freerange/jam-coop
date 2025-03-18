# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_connect_account do
    user
    sequence(:stripe_identifier) { |n| "stripe-identifier-#{n}" }
  end
end
