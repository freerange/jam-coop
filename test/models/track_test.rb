# frozen_string_literal: true

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:track).valid?
  end

  test 'delegates artist to album' do
    track = build(:track)
    assert_equal track.artist, track.album.artist
  end

  test 'validates presence of title' do
    track = build(:track, title: '')
    assert_not track.valid?
  end

  test 'triggers transcoding on create' do
    track = build(:track)

    track.expects(:transcode)

    track.save
  end

  test 'triggers transcoding if original changes' do
    track = create(:track)

    track.expects(:transcode)

    track.original.attach(
      io: Rails.root.join('test/fixtures/files/track.wav').open,
      filename: 'track.wav',
      content_type: 'audio/x-wav'
    )
  end

  test 'does not trigger transcoding if nothing significant changes' do
    track = create(:track)

    track.expects(:transcode).never

    track.update!(updated_at: Time.current)
  end

  test '#transcode enqueues transcoding for each format' do
    track = create(:track)

    Transcode.formats.each_key do |format|
      TranscodeJob.expects(:perform_later).with(track, format: format.to_sym)
    end

    track.transcode
  end

  test '#preview_duration returns nil if no preview' do
    track = create(:track)
    assert_nil track.preview_duration
  end

  test '#preview_duration returns nil if transcode has not been analyzed' do
    track = create(:track)
    transcode = create(:transcode)
    track.transcodes << transcode

    assert_nil track.preview_duration
  end

  test '#preview_duration duration of preview in seconds' do
    track = create(:track)
    preview = stub(file: stub(metadata: { 'duration' => 200 }))
    track.stubs(:preview).returns(preview)

    assert_equal 200, track.preview_duration
  end

  test '#metadata' do
    track = create(:track)

    metadata = track.metadata

    assert_equal track.title, metadata[:track_title]
    assert_equal track.album.title, metadata[:album_title]
    assert_equal track.album.artist.name, metadata[:artist_name]
  end
end
