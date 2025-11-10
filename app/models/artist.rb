# frozen_string_literal: true

class Artist < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, 'music'],
      [:name, 'sounds']
    ]
  end

  belongs_to :user, optional: true
  has_many :albums, dependent: :destroy
  has_one_attached :profile_picture

  validates :name, presence: true

  scope :listed, -> { where.associated(:albums).where('albums.publication_status': :published).distinct }

  after_commit :transcode_albums, on: :update, if: :metadata_changed?

  def listed?
    albums.any? { it.published? }
  end

  def first_listed_on
    albums.minimum(:first_published_on)
  end

  def transcode_albums
    albums.each(&:transcode_tracks)
  end

  def metadata_changed?
    name_previously_changed?
  end
end
