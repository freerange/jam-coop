# frozen_string_literal: true

class TranscodeCommand
  def initialize(input, output, format)
    @input = input
    @output = output
    @format = format
  end

  def generate
    case @format
    when :mp3v0
      "ffmpeg -y -nostats -loglevel 0 -i #{@input.path} -codec:a libmp3lame -q:a 0 -f mp3 #{@output.path}"
    when :mp3128k
      "ffmpeg -y -nostats -loglevel 0 -i #{@input.path} -codec:a libmp3lame -b:a 128k -f mp3 #{@output.path}"
    when :flac
      "ffmpeg -y -nostats -loglevel 0 -i #{@input.path} -codec:a flac -f flac #{@output.path}"
    else
      raise ArgumentError, "unsupported format: #{@format}"
    end
  end

  def execute
    command = generate
    system(command)
  end
end
