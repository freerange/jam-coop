# frozen_string_literal: true

class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :artist

  enum :publication_status, { unpublished: 0, published: 1, pending: 2 }

  belongs_to :artist
  has_many :tracks, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :album
  has_many :downloads, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_one_attached :cover
  belongs_to :license, optional: true

  accepts_nested_attributes_for :tracks, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :license

  validates :title, presence: true
  validates :price, presence: true, numericality: true
  validates :released_on, comparison: { less_than_or_equal_to: Time.zone.today, allow_blank: true }
  validates :number_of_tracks, comparison: { greater_than: 0 }, if: :published?
  validates(
    :cover,
    attached: { message: 'file cannot be missing' },
    content_type: {
      in: %w[image/jpeg image/png],
      message: 'must be an image file (jpeg, png)'
    }
  )

  scope :published, -> { where(publication_status: :published) }
  scope :unpublished, -> { where(publication_status: :unpublished) }
  scope :pending, -> { where(publication_status: :pending) }
  scope :in_release_order, -> { order(Arel.sql('COALESCE(released_on, first_published_on) DESC NULLS LAST')) }
  scope :best_selling, -> { left_joins(:purchases).group(:id).order('COUNT(purchases.id) DESC') }

  after_commit :transcode_tracks, on: :update, if: :metadata_or_cover_changed?

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
    saved = update(publication_status: :published, first_published_on: first_published_on || Time.current)
    if saved
      ZipDownloadJob.perform_later(self, format: :mp3v0)
      ZipDownloadJob.perform_later(self, format: :flac)
    end
    saved
  end

  def unpublish
    unpublished!
  end

  def released_on
    super || first_published_on
  end

  def number_of_tracks
    tracks.length
  end

  def metadata_or_cover_changed?
    title_previously_changed? || attachment_changes['cover'].present?
  end
end
