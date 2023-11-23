# frozen_string_literal: true

class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :artist

  enum :publication_status, { unpublished: 0, published: 1, pending: 2 }

  validates :title, presence: true
  validates :price, presence: true, numericality: true

  belongs_to :artist
  has_many :tracks, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :album
  accepts_nested_attributes_for :tracks, reject_if: :all_blank, allow_destroy: true
  has_many :downloads, dependent: :destroy

  has_one_attached :cover

  scope :published, -> { where(publication_status: :published) }
  scope :unpublished, -> { where(publication_status: :unpublished) }
  scope :in_release_order, -> { order('released_at DESC NULLS LAST') }

  after_update :transcode_tracks, if: :metadata_or_cover_changed?

  def preview
    first_track_with_preview = tracks.detect(&:preview)
    first_track_with_preview&.preview
  end

  def transcode_tracks
    tracks.each(&:transcode)
  end

  def pending
    pending!
  end

  def publish
    published!

    ZipDownloadJob.perform_later(self, format: :mp3v0)
    ZipDownloadJob.perform_later(self, format: :flac)
  end

  def unpublish
    unpublished!
  end

  def metadata_or_cover_changed?
    title_previously_changed? || attachment_changes['cover'].present?
  end
end
