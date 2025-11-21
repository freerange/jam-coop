# frozen_string_literal: true

FactoryBot.define do
  factory :following do
    user
    artist
  end
end
