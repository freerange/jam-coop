# frozen_string_literal: true

class TranscodeCommand
  def initialize(input, output, format)
    @input = input
    @output = output
    @format = format
  end

  def generate
    "ffmpeg #{global_options} -i #{@input.path} #{transcoding_options(@format)} #{@output.path}"
  end

  def execute
    command = generate
    system(command)
  end

  def global_options
    '-y -nostats -loglevel 0'
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
end
