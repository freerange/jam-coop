# frozen_string_literal: true

require 'test_helper'

class TranscodeJobTest < ActiveJob::TestCase
  test 'it transcodes the file to mp3v0 by default' do
    track = create(:track)

    TranscodeJob.perform_now(track)

    assert 1, track.transcodes.mp3v0.count
  end

  test 'it supports transcoding the file to mp3128k' do
    track = create(:track)

    TranscodeJob.perform_now(track, format: :mp3128k)

    assert 1, track.transcodes.mp3128k.count
  end

  test 'it removes an old transcode before creating a new one' do
    track = create(:track)
    TranscodeJob.perform_now(track)
    old_transcode = track.transcodes.last
    TranscodeJob.perform_now(track)
    new_transcode = track.transcodes.last

    assert_equal 1, track.transcodes.count
    assert_not_equal old_transcode.file, new_transcode.file
  end
end
