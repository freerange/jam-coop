# frozen_string_literal: true

FactoryBot.define do
  factory :artist do
    name { 'Rick Astley' }

    after(:build) do |artist|
      artist.profile_picture.attach(
        io: Rails.root.join('test/fixtures/files/cover.png').open,
        filename: 'profile.png',
        content_type: 'image/png'
      )
    end
  end
end
