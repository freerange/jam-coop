# frozen_string_literal: true

class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :artist

  validates :title, presence: true

  belongs_to :artist
  has_many :tracks, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :album
  has_many :downloads, dependent: :destroy

  has_one_attached :cover

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }

  def preview
    first_track_with_preview = tracks.detect(&:preview)
    first_track_with_preview&.preview
  end

  def retranscode!
    tracks.each(&:transcode)
  end

  def publish
    update(published: true)
  end

  def unpublish
    update(published: false)
  end
end
