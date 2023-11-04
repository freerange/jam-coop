# frozen_string_literal: true

class TranscodeCommand
  METADATA_KEYS_VS_ID3V23_TAGS = {
    track_title: 'TIT2',
    album_title: 'TALB',
    artist_name: 'TPE1'
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
      metadata_options,
      transcoding_options(@format),
      @output.path
    ].join(' ')
  end

  def execute
    command = generate
    system(command)
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

  def metadata_options
    supported_keys = @metadata.slice(*id3v23_keys)
    return if supported_keys.empty?

    entries = supported_keys.map { |k, v| %(-metadata #{id3v23_key_for(k)}="#{v}") }
    "-write_id3v2 1 -id3v2_version 3 #{entries.join(' ')}"
  end

  def transcoding_options(format)
    case format
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

  def id3v23_keys
    METADATA_KEYS_VS_ID3V23_TAGS.keys
  end

  def id3v23_key_for(key)
    METADATA_KEYS_VS_ID3V23_TAGS[key]
  end
end
