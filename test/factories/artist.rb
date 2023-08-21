# frozen_string_literal: true

FactoryBot.define do
  factory :artist do
    name { 'Rick Astley' }
    location { 'Molesey, UK' }
    description do
      'Richard Paul Astley (born 6 February 1966) is an English singer who has been active in music for several decades'
    end

    after(:build) do |artist|
      artist.profile_picture.attach(
        io: Rails.root.join('test/fixtures/files/cover.png').open,
        filename: 'profile.png',
        content_type: 'image/png'
      )
    end
  end
end
