# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :album
  acts_as_list scope: :album

  has_many :transcodes, dependent: :destroy

  delegate :artist, to: :album

  has_one_attached :original
  validates :original, attached: true, content_type: { in: 'audio/x-wav', message: 'must be a WAV file' }
  validates :title, presence: true

  after_save :transcode, if: proc { |track| track.attachment_changes.any? }

  def preview
    transcodes.where(format: 'mp3v0').first
  end

  private

  def transcode
    TranscodeJob.perform_later(self)
  end
end
