# frozen_string_literal: true

class TranscodeCommand
  METADATA_KEYS_VS_ID3V23_TAGS = {
    track_title: 'TIT2',
    track_number: 'TRCK',
    album_title: 'TALB',
    artist_name: 'TPE1',
    release_date: 'DATE'
  }.freeze

  METADATA_KEYS_VS_FLAC_TAGS = {
    track_title: 'TITLE',
    track_number: 'TRACKNUMBER',
    album_title: 'ALBUM',
    artist_name: 'ARTIST',
    release_date: 'DATE'
  }.freeze

  def initialize(input, output, format, metadata = {}, image = nil)
    @input = input
    @output = output
    @format = format
    @metadata = metadata
    @image = image
  end

  def generate
    [
      'ffmpeg',
      global_options,
      input_options,
      image_options,
      muxer_options,
      metadata_options,
      transcoding_options,
      @output.path
    ].compact.join(' ')
  end

  def execute
    command = generate
    system(command, exception: true)
  end

  def global_options
    '-y -nostats -loglevel 0'
  end

  def input_options
    "-i #{@input.path}"
  end

  def image_options
    return if @image.blank?

    "-i #{@image.path} -map 0:0 -map 1:0 -c copy"
  end

  def muxer_options
    return unless @format.to_s =~ /^mp3/

    '-write_id3v2 1 -id3v2_version 3'
  end

  def metadata_options
    supported_keys = @metadata.slice(*tag_keys)
    return if supported_keys.empty?

    supported_keys.map { |k, v| %(-metadata #{tag_key_for(k)}="#{v}") }.join(' ')
  end

  def transcoding_options
    case @format
    when :mp3v0
      '-codec:a libmp3lame -q:a 0 -f mp3'
    when :mp3128k
      '-codec:a libmp3lame -b:a 128k -f mp3'
    when :flac
      '-codec:a flac -f flac'
    else
      raise ArgumentError, "unsupported format: #{@format}"
    end
  end

  def tag_keys
    metadata_lookup.keys
  end

  def tag_key_for(key)
    metadata_lookup[key]
  end

  def metadata_lookup
    case @format.to_s
    when /^mp3/
      METADATA_KEYS_VS_ID3V23_TAGS
    when /^flac/
      METADATA_KEYS_VS_FLAC_TAGS
    else
      raise ArgumentError, "unsupported format: #{@format}"
    end
  end
end
