# frozen_string_literal: true

class TranscodeJob < ApplicationJob
  queue_as :default

  def perform(track, format: :mp3v0)
    output_fn = "#{track.original.filename.base}.mp3"

    Tempfile.create('transcode') do |output|
      track.original.open { |file| transcode(file, output, format) }
      track.transcodes.where(format:).destroy_all
      transcode = track.transcodes.create(format:)
      transcode.file.attach(io: File.open(output.path), filename: output_fn, content_type: 'audio/mpeg')
    end
  end

  private

  def transcode(input, output, format)
    case format
    when :mp3v0
      cmd = "ffmpeg -y -nostats -loglevel 0 -i #{input.path} -codec:a libmp3lame -q:a 0 -f mp3 #{output.path}"
    when :mp3128k
      cmd = "ffmpeg -y -nostats -loglevel 0 -i #{input.path} -codec:a libmp3lame -b:a 128k -f mp3 #{output.path}"
    else
      raise ArgumentError, "unsupported format: #{format}"
    end

    system(cmd)
  end
end
