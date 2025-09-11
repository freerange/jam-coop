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
    publication_status { :unpublished }
    released_on { Time.zone.today }
    license

    after(:build) do |album|
      album.cover.attach(
        io: Rails.root.join('test/fixtures/files/cover.png').open,
        filename: 'cover.png',
        content_type: 'image/png'
      )
    end

    trait :with_tracks do
      transient do
        number_of_tracks { 2 }
      end

      after(:build) do |album, evaluator|
        album.tracks = build_list(:track, evaluator.number_of_tracks, album:)
      end
    end
  end

  factory :album_with_tracks, parent: :album, traits: %i[with_tracks]

  factory :unpublished_album, parent: :album do
    publication_status { :unpublished }
  end

  factory :published_album, parent: :album, traits: %i[with_tracks] do
    publication_status { :published }
  end
end
