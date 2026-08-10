# frozen_string_literal: true

require 'open3'

class ReadMetadataCommand
  def initialize(blob)
    @blob = blob
  end

  def execute
    @blob.open do |file|
      stdout, stderr, status = Open3.capture3(
        'ffprobe',
        '-v', 'error',
        '-print_format', 'json',
        '-show_format',
        file.path
      )

      raise "ffprobe failed: #{stderr}" unless status.success?

      hash = JSON.parse(stdout)
      tags = hash.dig('format', 'tags') || {}
      tags.transform_keys { it.downcase.to_sym }
    end
  end
end
