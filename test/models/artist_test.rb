# frozen_string_literal: true

require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'fixture is valid' do
    assert build(:artist).valid?
  end

  test '.listed' do
    listed_artist = create(:artist, name: 'Listed', listed: true)
    create(:artist, name: 'Unlisted', listed: false)

    assert_equal [listed_artist], Artist.listed
  end

  test '.unlisted' do
    unlisted_artist = create(:artist, name: 'Unlisted', listed: false)
    create(:artist, name: 'Listed', listed: true)

    assert_equal [unlisted_artist], Artist.unlisted
  end

  test 'uses a friendly id' do
    artist = create(:artist, name: 'Rick Astley')

    assert_equal artist, Artist.friendly.find('rick-astley')
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
