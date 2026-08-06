# frozen_string_literal: true

module OriginalAudio
  class << self
    def content_types = %w[audio/x-wav audio/flac]

    def file_types = %w[WAV FLAC]
  end
end
