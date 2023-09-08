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

  test 'enqueues transcoding on save' do
    track = build(:track)
    TranscodeJob.expects(:perform_later).with(track)

    track.save
  end

  test 'enqueues transcoding only if original has changed' do
    track = create(:track)
    TranscodeJob.expects(:perform_later).never

    track.save
  end
end
