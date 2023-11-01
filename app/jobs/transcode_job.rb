# frozen_string_literal: true

class TranscodeJob < ApplicationJob
  queue_as :default

  def perform(track, format: :mp3v0)
    output_fn = "#{track.original.filename.base}.#{file_extension(format)}"

    Tempfile.create('transcode') do |output|
      track.original.open { |file| transcode(file, output, format) }
      track.transcodes.where(format:).destroy_all
      transcode = track.transcodes.create(format:)
      transcode.file.attach(io: File.open(output.path), filename: output_fn, content_type: content_type(format))
    end
  end

  private

  def transcode(input, output, format)
    case format
    when :mp3v0
      cmd = "ffmpeg -y -nostats -loglevel 0 -i #{input.path} -codec:a libmp3lame -q:a 0 -f mp3 #{output.path}"
    when :mp3128k
      cmd = "ffmpeg -y -nostats -loglevel 0 -i #{input.path} -codec:a libmp3lame -b:a 128k -f mp3 #{output.path}"
    when :flac
      cmd = "ffmpeg -y -nostats -loglevel 0 -i #{input.path} -codec:a flac -f flac #{output.path}"
    else
      raise ArgumentError, "unsupported format: #{format}"
    end

    system(cmd)
  end

  def content_type(format)
    case format
    when :mp3v0, :mp3128k
      'audio/mpeg'
    when :flac
      'audio/flac'
    else
      raise ArgumentError, "unsupported format: #{format}"
    end
  end

  def file_extension(format)
    case format
    when :mp3v0, :mp3128k
      'mp3'
    when :flac
      'flac'
    else
      raise ArgumentError, "unsupported format: #{format}"
    end
  end
end
