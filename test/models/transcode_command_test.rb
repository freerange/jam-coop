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
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-loglevel', '0'] })
  end

  test 'specifies input file' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-i', @input.path] })
  end

  test 'adds image to output' do
    image = Tempfile.create('transcode-image')
    command_string = TranscodeCommand.new(@input, @output, :mp3v0, {}, image).generate
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-i', image.path] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-map', '0:0'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-map', '1:0'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-c', 'copy'] })
  end

  test 'adds metadata using ID3v2.3 format' do
    metadata = { track_title: 'track-title', album_title: 'album-title', artist_name: 'artist-name' }
    command_string = TranscodeCommand.new(@input, @output, :mp3v0, metadata).generate
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-write_id3v2', '1'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-id3v2_version', '3'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-metadata', 'TIT2="track-title"'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-metadata', 'TALB="album-title"'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-metadata', 'TPE1="artist-name"'] })
  end

  test 'transcodes audio to mp3 using libmp3lame codec highest audio quality' do
    command_string = TranscodeCommand.new(@input, @output, :mp3v0).generate
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-codec:a', 'libmp3lame'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-q:a', '0'] })
  end

  test 'transcodes audio to mp3128k using libmp3lame codec with bitrate of 128k & file format mp3' do
    command_string = TranscodeCommand.new(@input, @output, :mp3128k).generate
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-codec:a', 'libmp3lame'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-b:a', '128k'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-f', 'mp3'] })
  end

  test 'transcodes audio to flac using flac codec with file format flac' do
    command_string = TranscodeCommand.new(@input, @output, :flac).generate
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-codec:a', 'flac'] })
    assert(command_string.split.each_cons(2).any? { |pair| pair == ['-f', 'flac'] })
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
end
