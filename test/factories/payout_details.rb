# frozen_string_literal: true

FactoryBot.define do
  factory :payout_detail do
    name { 'John Lennon' }
    country { 'united_kingdom' }
    user
  end
end
