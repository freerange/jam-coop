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

  test 'it supports transcoding the file to flac' do
    track = create(:track)

    TranscodeJob.perform_now(track, format: :flac)

    assert 1, track.transcodes.flac.count
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

  test 'uses /var/data for tmp files when that path exists' do
    Dir.stubs(:exist?).with('/var/data').returns(true)
    Tempfile.expects(:create).with('transcode', '/var/data')

    TranscodeJob.perform_now(build(:track))
  end

  test 'uses default for tmp files when /var/data does not exist' do
    Dir.stubs(:exist?).with('/var/data').returns(false)
    Tempfile.expects(:create).with('transcode', nil)

    TranscodeJob.perform_now(build(:track))
  end

  test 'it adds metadata to the generated MP3 file' do
    album = create(:album, released_on: Date.parse('2024-10-03'))
    track = create(:track, album:)
    TranscodeJob.perform_now(track)

    track.transcodes.mp3v0.first.file.open do |file|
      cmd = "ffprobe -i #{file.path} -v quiet -print_format json -show_format"
      std_out, _status = Open3.capture2(cmd)
      metadata = JSON.parse(std_out)

      assert_equal track.title, metadata['format']['tags']['title']
      assert_equal '01', metadata['format']['tags']['track']
      assert_equal album.title, metadata['format']['tags']['album']
      assert_equal album.artist.name, metadata['format']['tags']['artist']
      assert_equal '2024', metadata['format']['tags']['TORY']
    end
  end

  test 'it adds metadata to the generated flac file' do
    album = create(:album, released_on: Date.parse('2024-10-03'))
    track = create(:track, album:)
    TranscodeJob.perform_now(track, format: :flac)

    track.transcodes.flac.first.file.open do |file|
      cmd = "ffprobe -i #{file.path} -v quiet -print_format json -show_format"
      std_out, _status = Open3.capture2(cmd)
      metadata = JSON.parse(std_out)

      assert_equal track.title, metadata['format']['tags']['TITLE']
      assert_equal '01', metadata['format']['tags']['track']
      assert_equal album.title, metadata['format']['tags']['ALBUM']
      assert_equal album.artist.name, metadata['format']['tags']['ARTIST']
      assert_equal '2024', metadata['format']['tags']['DATE']
    end
  end
end
