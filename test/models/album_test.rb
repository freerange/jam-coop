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
    album = create(:album_with_tracks, number_of_tracks: 2)

    assert_enqueued_jobs 2 * Transcode.formats.count, only: TranscodeJob do
      album.transcode_tracks
    end
  end

  test 'publish sets published state' do
    album = create(:album, publication_status: :unpublished)
    album.publish
    assert album.published?
  end

  test 'publish sets first_published_on if not already set' do
    album = create(:album, publication_status: :unpublished)
    freeze_time do
      album.publish
      assert_equal Time.zone.today, album.first_published_on
    end
  end

  test 'publish does not set first_published_on if already set' do
    freeze_time do
      album = create(:album, publication_status: :unpublished, first_published_on: 1.week.ago)
      album.publish
      assert_equal 1.week.ago.to_date, album.first_published_on
    end
  end

  test 'publish enqueues ZipDownloadJob to prepare mp3v0 download' do
    album = create(:album, publication_status: :unpublished)

    args_matcher = ->(job_args) { job_args[1][:format] == :mp3v0 }
    assert_enqueued_with(job: ZipDownloadJob, args: args_matcher) do
      album.publish
    end
  end

  test 'publish enqueues ZipDownloadJob to prepare flac download' do
    album = create(:album, publication_status: :unpublished)

    args_matcher = ->(job_args) { job_args[1][:format] == :flac }
    assert_enqueued_with(job: ZipDownloadJob, args: args_matcher) do
      album.publish
    end
  end

  test 'unpublish' do
    album = create(:album, publication_status: :published)
    album.unpublish
    assert_not album.published?
  end

  test 'pending' do
    album = create(:album, publication_status: :unpublished)
    album.pending
    assert album.pending?
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
    create(:album, publication_status: :unpublished)

    assert_equal 1, Album.published.count
  end

  test '.unpublished' do
    create(:album)
    create(:album, publication_status: :unpublished)

    assert_equal 1, Album.unpublished.count
  end

  test '.in_release_order' do
    create(:album, title: 'Unknown', released_at: nil)
    create(:album, title: 'Older Published', released_at: nil, first_published_on: Date.parse('2023-01-01'))
    create(:album, title: 'Older Released', released_at: Date.parse('2023-02-01'))
    create(:album, title: 'Newer Published', released_at: nil, first_published_on: Date.parse('2023-03-01'))
    create(:album, title: 'Newer Released', released_at: Date.parse('2023-04-01'))

    expected_titles = ['Newer Released', 'Newer Published', 'Older Released', 'Older Published', 'Unknown']
    assert_equal expected_titles, Album.in_release_order.pluck(:title)
  end

  test 'released_at falls back to first_published_on' do
    freeze_time do
      album_with_released_at = build(:album, released_at: 1.day.ago, first_published_on: 2.days.ago)
      assert_equal 1.day.ago.to_date, album_with_released_at.released_at

      album_without_released_at = build(:album, released_at: nil, first_published_on: 2.days.ago)
      assert_equal 2.days.ago.to_date, album_without_released_at.released_at
    end
  end

  test 'is invalid with a non-numeric price' do
    album = build(:album, price: 'foo')
    assert_not album.valid?
  end

  test 'is not valid if cover is not present' do
    album = Album.new

    assert_not album.valid?
    assert_includes album.errors[:cover], 'file cannot be missing'
  end

  test 'is not valid if cover is not an image' do
    album = Album.new

    album.stubs(:transcode_tracks)

    album.cover.attach(
      io: Rails.root.join('test/fixtures/files/dummy.pdf').open,
      filename: 'dummy.pdf',
      content_type: 'application/pdf'
    )

    assert_not album.valid?
    assert_includes album.errors[:cover], 'must be an image file (jpeg, png)'
  end
end
