# frozen_string_literal: true

FactoryBot.define do
  factory :album do
    artist
    title { 'Whenever You Need Somebody' }
    price { 700 }
    about do
      'Whenever You Need Somebody is the debut studio album by English
       singer Rick Astley, released on 16 November 1987 by RCA
       Records.'
    end
    credits do
      'Rick Astley - vocals.'
    end
    publication_status { :published }

    after(:build) do |album|
      album.cover.attach(
        io: Rails.root.join('test/fixtures/files/cover.png').open,
        filename: 'cover.png',
        content_type: 'image/png'
      )
    end

    factory :album_with_tracks do
      transient do
        number_of_tracks { 2 }
      end

      after(:create) do |album, evaluator|
        create_list(:track, evaluator.number_of_tracks, album:)
        album.reload
      end
    end
  end
end
