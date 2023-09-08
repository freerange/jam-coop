# frozen_string_literal: true

class Transcode < ApplicationRecord
  belongs_to :track
  enum format: { mp3v0: 0 }
end
