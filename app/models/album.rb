# frozen_string_literal: true

class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :artist

  enum :publication_status, { draft: 0, published: 1 }

  belongs_to :artist
  has_many :tracks, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :album
  has_many :purchases, dependent: :destroy
  has_one_attached :cover
  belongs_to :license

  accepts_nested_attributes_for :tracks, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :price, presence: true, numericality: true
  validates :released_on, comparison: { less_than_or_equal_to: -> { Time.zone.today }, allow_blank: true }
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
  scope :draft, -> { where(publication_status: :draft) }
  scope :in_release_order, -> { order(Arel.sql('COALESCE(released_on, first_published_on) DESC NULLS LAST')) }
  scope :best_selling, -> { left_joins(:purchases).group(:id).order('COUNT(purchases.id) DESC') }
  scope :recently_released, -> { where.not(released_on: nil).order(released_on: :desc) }

  after_update :set_first_published_on, if: :saved_change_to_publication_status_to_published?
  after_commit :transcode_tracks, on: :update, if: :metadata_or_cover_changed?

  def preview
    first_track_with_preview = tracks.detect(&:preview)
    first_track_with_preview&.preview
  end

  def transcode_tracks
    tracks.each(&:transcode)
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

  private

  def saved_change_to_publication_status_to_published?
    saved_change_to_publication_status? && published?
  end

  def set_first_published_on
    return unless first_published_on.nil?

    self.first_published_on = Time.current
    save!
  end
end
