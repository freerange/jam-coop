# frozen_string_literal: true

class Download < ApplicationRecord
  belongs_to :album
  enum format: { mp3v0: 0, mp3128k: 1, flac: 2 }
  has_one_attached :file
end
