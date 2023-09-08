# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :album
  has_many :transcodes, dependent: :destroy

  delegate :artist, to: :album

  has_one_attached :original
  validates :original, attached: true, content_type: { in: 'audio/x-wav', message: 'must be a WAV file' }

  after_save :transcode, if: proc { |track| track.attachment_changes.any? }

  private

  def transcode
    TranscodeJob.perform_later(self)
  end
end
