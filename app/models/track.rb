# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :album
  acts_as_list scope: :album

  has_many :transcodes, dependent: :destroy

  delegate :artist, :unpublished?, to: :album

  has_one_attached :original
  validates :original,
            attached: { message: 'file cannot be missing' },
            content_type: { in: 'audio/x-wav', message: 'must be a WAV file' }
  validates :title, presence: true

  after_commit :transcode, on: %i[create update], if: :metadata_or_original_changed?

  def preview
    transcodes.mp3128k.first
  end

  def preview_duration
    return nil unless preview

    preview.file.metadata['duration']
  end

  def metadata
    {
      track_title: title,
      track_number: number,
      album_title: album.title,
      artist_name: artist.name
    }
  end

  def transcode
    Transcode.formats.each_key do |format|
      TranscodeJob.perform_later(self, format: format.to_sym)
    end
  end

  def metadata_or_original_changed?
    title_previously_changed? || position_previously_changed? || attachment_changes['original'].present?
  end

  def number
    position.to_s.rjust(2, '0')
  end
end
