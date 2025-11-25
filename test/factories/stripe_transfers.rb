# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_transfer do
    stripe_account
    purchase
    amount_in_pence { 700 }
  end
end
