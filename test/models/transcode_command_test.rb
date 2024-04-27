# frozen_string_literal: true

require 'test_helper'

class TranscodeCommandTest < ActiveSupport::TestCase
  setup do
    @input = Tempfile.create('transcode-input')
    @output = Tempfile.create('transcode-output')
  end

  test 'generates ffmpeg command' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert_equal 'ffmpeg', command_string.split.first
  end

  test 'overwrites output files without asking' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert command_string.split.include?('-y')
  end

  test 'do not print encoding progress/statistics' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert command_string.split.include?('-nostats')
  end

  test 'only show fatal errors which could lead the process to crash, such as an assertion failure' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert_contains_pair(command_string, ['-loglevel', '0'])
  end

  test 'specifies input file' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert_contains_pair(command_string, ['-i', @input.path])
  end

  test 'adds image to output' do
    image = Tempfile.create('transcode-image')
    command_string = TranscodeCommand.new(@input, @output, :mp3v0, {}, image).generate
    assert_contains_pair(command_string, ['-i', image.path])
    assert_contains_pair(command_string, ['-map', '0:0'])
    assert_contains_pair(command_string, ['-map', '1:0'])
    assert_contains_pair(command_string, ['-c', 'copy'])
  end

  test 'adds metadata tags using ID3v2.3 format for MP3 formats' do
    metadata = {
      track_title: 'track-title',
      track_number: 'track-number',
      album_title: 'album-title',
      artist_name: 'artist-name'
    }
    command_string = TranscodeCommand.new(@input, @output, :mp3v0, metadata).generate
    assert_contains_pair(command_string, ['-write_id3v2', '1'])
    assert_contains_pair(command_string, ['-id3v2_version', '3'])
    assert_contains_pair(command_string, ['-metadata', 'TIT2="track-title"'])
    assert_contains_pair(command_string, ['-metadata', 'TRCK="track-number"'])
    assert_contains_pair(command_string, ['-metadata', 'TALB="album-title"'])
    assert_contains_pair(command_string, ['-metadata', 'TPE1="artist-name"'])
  end

  test 'transcodes audio to mp3 using libmp3lame codec highest audio quality' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert_contains_pair(command_string, ['-codec:a', 'libmp3lame'])
    assert_contains_pair(command_string, ['-q:a', '0'])
  end

  test 'transcodes audio to mp3128k using libmp3lame codec with bitrate of 128k & file format mp3' do
    command_string = TranscodeCommand.new(@input, @output, :mp3128k).generate
    assert_contains_pair(command_string, ['-codec:a', 'libmp3lame'])
    assert_contains_pair(command_string, ['-b:a', '128k'])
    assert_contains_pair(command_string, ['-f', 'mp3'])
  end

  test 'transcodes audio to flac using flac codec with file format flac' do
    command_string = TranscodeCommand.new(@input, @output, :flac).generate
    assert_contains_pair(command_string, ['-codec:a', 'flac'])
    assert_contains_pair(command_string, ['-f', 'flac'])
  end

  test 'specifies output file' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert_equal @output.path, command_string.split.last
  end

  test 'raises exception if format is unsupported' do
    e = assert_raises(ArgumentError) { TranscodeCommand.new(@input, @output, :aac).generate }
    assert_equal 'unsupported format: aac', e.message
  end

  test 'executes generated ffmpeg command' do
    command = TranscodeCommand.new(@input, @output, :mp3v0)
    command_string = command.generate
    command.expects(:system).with(command_string, exception: true)
    command.execute
  end

  private

  def assert_contains_pair(string, expected_pair)
    assert(string.split.each_cons(2).any? { |pair| pair == expected_pair })
  end
end
