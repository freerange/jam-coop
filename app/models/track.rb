# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :album
  delegate :artist, to: :album

  has_one_attached :original
  validates :original, attached: true, content_type: { in: 'audio/x-wav', message: 'must be a WAV file' }
end
