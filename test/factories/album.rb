# frozen_string_literal: true

FactoryBot.define do
  factory :album do
    artist
    title { 'Whenever You Need Somebody' }

    after(:build) do |album|
      album.cover.attach(
        io: Rails.root.join('test/fixtures/files/cover.png').open,
        filename: 'cover.png',
        content_type: 'image/png'
      )
    end

    factory :album_with_tracks do
      after(:create) do |album|
        create_list(:track, 2, album:)
        album.reload
      end
    end
  end
end
