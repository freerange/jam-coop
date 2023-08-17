# frozen_string_literal: true

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:album).valid?
  end

  test 'uses a friendly id' do
    album = create(:album, title: 'Who? What? Where?')

    assert_equal album, Album.friendly.find('who-what-where')
  end

  test 'scopes the slug to the parent artist' do
    artist = create(:artist, name: 'Artist 1')
    different_artist = create(:artist, name: 'Artist 2')
    title = 'Same Title'

    album = create(:album, artist:, title:)
    album_by_different_artist = create(:album, artist: different_artist, title:)
    album_with_same_title_by_same_artist = create(:album, artist:, title:)

    assert_equal album.slug, album_by_different_artist.slug
    assert_not_equal album.slug, album_with_same_title_by_same_artist.slug
  end

  test 'orders tracks by their position' do
    album = create(:album)

    first_track = create(:track, position: 1, album:)
    second_track = create(:track, position: 2, album:)

    album.tracks << second_track
    album.tracks << first_track

    assert_equal album.tracks, [first_track, second_track]
  end
end
