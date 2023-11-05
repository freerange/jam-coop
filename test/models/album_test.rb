# frozen_string_literal: true

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

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

  test 'preview returns a transcode' do
    album = create(:album)
    track = create(:track, album:)
    transcode = create(:transcode, track:)

    assert_equal album.preview, transcode
  end

  test 'preview with multiple tracks returns first with a transcode' do
    album = create(:album)
    create(:track, album:)
    track = create(:track, album:)
    transcode = create(:transcode, track:)

    assert_equal album.preview, transcode
  end

  test 'preview returns false if there are no transcodes' do
    album = create(:album)
    create(:track, album:)

    assert_not album.preview
  end

  test 'transcode_tracks' do
    album = create(:album)
    create(:track, album:)

    assert_enqueued_with(job: TranscodeJob) do
      album.transcode_tracks
    end
  end

  test 'publish sets published state' do
    album = create(:album, published: false)
    album.publish
    assert album.published?
  end

  test 'publish enqueues ZipDownloadJob to prepare mp3v0 download' do
    album = create(:album, published: false)

    args_matcher = ->(job_args) { job_args[1][:format] == :mp3v0 }
    assert_enqueued_with(job: ZipDownloadJob, args: args_matcher) do
      album.publish
    end
  end

  test 'publish enqueues ZipDownloadJob to prepare flac download' do
    album = create(:album, published: false)

    args_matcher = ->(job_args) { job_args[1][:format] == :flac }
    assert_enqueued_with(job: ZipDownloadJob, args: args_matcher) do
      album.publish
    end
  end

  test 'unpublish' do
    album = create(:album, published: true)
    album.unpublish
    assert_not album.published?
  end

  test 'triggers transcoding of tracks if cover changes' do
    album = create(:album)

    album.expects(:transcode_tracks)

    album.cover.attach(
      io: Rails.root.join('test/fixtures/files/cover.png').open,
      filename: 'cover.png',
      content_type: 'image/png'
    )
  end

  test 'triggers transcoding of tracks if title changes' do
    album = create(:album)

    album.expects(:transcode_tracks)

    album.update!(title: 'new-title')
  end

  test 'does not trigger transcoding of tracks if nothing significant changes' do
    album = create(:album)

    album.expects(:transcode_tracks).never

    album.update!(updated_at: Time.current)
  end

  test '.published' do
    create(:album)
    create(:album, published: false)

    assert_equal 1, Album.published.count
  end

  test '.unpublished' do
    create(:album)
    create(:album, published: false)

    assert_equal 1, Album.unpublished.count
  end

  test '.in_release_order' do
    create(:album, title: 'Older', released_at: Date.parse('2023-01-01'))
    create(:album, title: 'Newer', released_at: Date.parse('2023-02-01'))
    create(:album, title: 'Unknown', released_at: nil)

    assert_equal %w[Newer Older Unknown], Album.in_release_order.pluck(:title)
  end

  test 'is invalid with a non-numeric price' do
    album = build(:album, price: 'foo')
    assert_not album.valid?
  end
end
