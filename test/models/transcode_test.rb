# frozen_string_literal: true

require 'test_helper'

class TranscodeTest < ActiveSupport::TestCase
  test 'fixture is valid' do
    assert build(:transcode).valid?
  end

  test 'validates only one of each format exists for each track' do
    track = create(:track)
    different_track = create(:track)
    create(:transcode, format: :mp3v0, track:)

    duplicate_transcode = build(:transcode, format: :mp3v0, track:)

    assert_not duplicate_transcode.valid?

    different_track_transcode = build(:transcode, format: :mp3v0, track: different_track)

    assert different_track_transcode.valid?
  end
end
