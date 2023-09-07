# frozen_string_literal: true

FactoryBot.define do
  factory :track do
    album
    sequence(:title) { |n| "Never gonna give you up #{n}" }
    sequence(:position) { |n| n }

    after(:build) do |track|
      track.original.attach(
        io: Rails.root.join('test/fixtures/files/track.wav').open,
        filename: 'track.wav',
        content_type: 'audio/x-wav'
      )
    end
  end
end
