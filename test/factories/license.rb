# frozen_string_literal: true

FactoryBot.define do
  factory :license do
    code { Faker::Alphanumeric.alpha(number: 10) }
    label { Faker::Alphanumeric.alpha(number: 15) }
  end
end
