# frozen_string_literal: true

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'fixture is valid' do
    assert build(:artist).valid?
  end

  test '.listed returns artists that have any published albums' do
    published_album = create(:published_album)
    unpublished_album = create(:unpublished_album)
    listed_artist = create(:artist, name: 'Listed', albums: [published_album, unpublished_album])
    create(:artist, name: 'Unlisted', albums: [unpublished_album])

    assert_equal [listed_artist], Artist.listed
  end

  test '.listed only returns artist once if they have multiple published albums' do
    published_album = create(:published_album)
    another_published_album = create(:published_album)
    listed_artist = create(:artist, name: 'Listed', albums: [published_album, another_published_album])

    assert_equal [listed_artist], Artist.listed
  end

  test '#listed?' do
    published_album = create(:published_album)
    unpublished_album = create(:unpublished_album)

    artist = create(:artist)
    assert_not artist.listed?

    artist.albums << unpublished_album
    assert_not artist.listed?

    artist.albums << published_album
    assert artist.listed?
  end

  test '#first_listed_on returns oldest Album#first_published_on' do
    newer_album = build(:published_album, first_published_on: Date.parse('2023-01-02'))
    older_album = build(:unpublished_album, first_published_on: Date.parse('2023-01-01'))
    album_without_date = build(:pending_album, first_published_on: nil)
    artist = create(:artist, albums: [newer_album, older_album, album_without_date])

    assert_equal older_album.first_published_on, artist.first_listed_on
  end

  test 'uses a friendly id' do
    artist = create(:artist, name: 'Rick Astley')

    assert_equal artist, Artist.friendly.find('rick-astley')
  end

  test 'uses slug candidates in case of clashses' do
    assert_equal 'rick-astley', create(:artist, name: 'Rick Astley').slug
    assert_equal 'rick-astley-music', create(:artist, name: 'Rick Astley').slug
    assert_equal 'rick-astley-sounds', create(:artist, name: 'Rick Astley').slug
    assert_match(/rick-astley-*/, create(:artist, name: 'Rick Astley').slug)
  end

  test 'transcode_albums' do
    artist = create(:artist)
    create(:album_with_tracks, artist:, number_of_tracks: 2)
    create(:album_with_tracks, artist:, number_of_tracks: 1)

    assert_enqueued_jobs (2 + 1) * Transcode.formats.count, only: TranscodeJob do
      artist.transcode_albums
    end
  end

  test 'triggers transcoding of albums if name changes' do
    artist = create(:artist)

    artist.expects(:transcode_albums)

    artist.update!(name: 'new-name')
  end

  test 'does not trigger transcoding of albums if nothing significant changes' do
    artist = create(:artist)

    artist.expects(:transcode_albums).never

    artist.update!(updated_at: Time.current)
  end
end
