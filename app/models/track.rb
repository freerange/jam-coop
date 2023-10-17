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
    transcodes.mp3128k.first
  end

  private

  def transcode
    Transcode.formats.each_key do |format|
      TranscodeJob.perform_later(self, format: format.to_sym)
    end
  end
end
