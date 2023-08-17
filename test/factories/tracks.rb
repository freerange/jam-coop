# frozen_string_literal: true

FactoryBot.define do
  factory :track do
    album
    sequence(:title) { |n| "Never gonna give you up #{n}" }
    sequence(:position) { |n| n }
  end
end
