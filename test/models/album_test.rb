# frozen_string_literal: true

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'factory is valid' do
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

  test 'published! sets published state' do
    album = create(:draft_album, :with_tracks)
    album.published!
    assert album.published?
  end

  test 'published! sets first_published_on if not already set' do
    album = create(:draft_album, :with_tracks)
    freeze_time do
      album.published!
      assert_equal Time.current.to_date, album.reload.first_published_on
    end
  end

  test 'published! does not set first_published_on if already set' do
    freeze_time do
      album = create(:draft_album, :with_tracks, first_published_on: 1.week.ago)
      album.published!
      assert_equal 1.week.ago.to_date, album.reload.first_published_on
    end
  end

  test 'updating publication_status to published sets first_published_on if not already set' do
    album = create(:draft_album, :with_tracks)
    freeze_time do
      album.update!(publication_status: :published)
      assert_equal Time.current.to_date, album.reload.first_published_on
    end
  end

  test 'updating publication_status to published does not set first_published_on if already set' do
    freeze_time do
      album = create(:draft_album, :with_tracks, first_published_on: 1.week.ago)
      album.update!(publication_status: :published)
      assert_equal 1.week.ago.to_date, album.reload.first_published_on
    end
  end

  test 'changing other attributes does not affect first_published_on' do
    album = create(:draft_album)
    album.update!(title: 'New Title')
    assert_nil album.reload.first_published_on
  end

  test 'newly created published albums have a first_published_on' do
    album = create(:published_album)

    assert_not_nil album.reload.first_published_on
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
    published_album = create(:published_album)
    create(:draft_album)

    assert_equal [published_album], Album.published
  end

  test '.draft' do
    create(:published_album)
    draft_album = create(:draft_album)

    assert_equal [draft_album], Album.draft
  end

  test '.best_selling' do
    album_with_no_purchases = create(:album)
    album_with_one_purchase = create(:album)
    album_with_two_purchases = create(:album)
    create(:purchase, album: album_with_one_purchase, price: album_with_one_purchase.price)
    create(:purchase, album: album_with_two_purchases, price: album_with_two_purchases.price)
    create(:purchase, album: album_with_two_purchases, price: album_with_two_purchases.price)

    assert_equal [album_with_two_purchases, album_with_one_purchase, album_with_no_purchases], Album.best_selling
  end

  test '.in_release_order' do
    create(:album, title: 'Unknown', released_on: nil)
    create(:album, title: 'Older Published', released_on: nil, first_published_on: Date.parse('2023-01-01'))
    create(:album, title: 'Older Released', released_on: Date.parse('2023-02-01'))
    create(:album, title: 'Newer Published', released_on: nil, first_published_on: Date.parse('2023-03-01'))
    create(:album, title: 'Newer Released', released_on: Date.parse('2023-04-01'))

    expected_titles = ['Newer Released', 'Newer Published', 'Older Released', 'Older Published', 'Unknown']
    assert_equal expected_titles, Album.in_release_order.pluck(:title)
  end

  test 'released_on falls back to first_published_on' do
    freeze_time do
      album_with_released_on = build(:album, released_on: 1.day.ago, first_published_on: 2.days.ago)
      assert_equal 1.day.ago.to_date, album_with_released_on.released_on

      album_without_released_on = build(:album, released_on: nil, first_published_on: 2.days.ago)
      assert_equal 2.days.ago.to_date, album_without_released_on.released_on
    end
  end

  test '.recently_released returns most recent released album per artist' do
    artist1 = create(:artist)
    artist2 = create(:artist)

    older_album_artist1 = create(:album, artist: artist1, released_on: 4.months.ago)
    newer_album_artist1 = create(:album, artist: artist1, released_on: 3.months.ago)
    older_album_artist2 = create(:album, artist: artist2, released_on: 2.months.ago)
    newer_album_artist2 = create(:album, artist: artist2, released_on: 1.month.ago)
    create(:album, artist: artist1, released_on: nil)

    recently_released = Album.recently_released.map(&:id)

    assert_equal [newer_album_artist2.id,
                  older_album_artist2.id,
                  newer_album_artist1.id,
                  older_album_artist1.id],
                 recently_released
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

  test 'is not valid if released_on is a date in the future' do
    freeze_time do
      album = build(:album, released_on: 1.day.from_now)
      assert_not album.valid?
      assert_includes album.errors[:released_on], "must be less than or equal to #{Time.zone.today}"
    end
  end

  test 'is valid if not published and has no tracks' do
    album = build(:draft_album, tracks: [])
    assert album.valid?
  end

  test 'is not valid if published and has no tracks' do
    album = build(:album, tracks: [], publication_status: :published)
    assert_not album.valid?
    assert_includes album.errors[:number_of_tracks], 'must be greater than 0'
  end
end
