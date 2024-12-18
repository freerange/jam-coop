# frozen_string_literal: true

class Transcode < ApplicationRecord
  belongs_to :track
  enum :format, { mp3v0: 0, mp3128k: 1, flac: 2 }
  has_one_attached :file

  validates :format, presence: true, uniqueness: { scope: [:track_id] }
end
