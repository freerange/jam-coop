# frozen_string_literal: true

FactoryBot.define do
  factory :payout do
    user
    payout_type { 'Unknown' }
    sequence(:transaction_reference) { |n| "transaction-ref-#{n}" }
    sequence(:destination_reference) { |n| "destination-ref-#{n}" }
    amount_in_pence { 500 }
    platform_fee_in_pence { 100 }
  end

  factory :stripe_payout, parent: :payout do
    payout_type { Payout::STRIPE_TYPE }
  end
end
