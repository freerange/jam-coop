# frozen_string_literal: true

FactoryBot.define do
  factory :profile_link do
    artist
    url { 'http://example.com' }
  end
end
