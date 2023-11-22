# frozen_string_literal: true

class Artist < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user, optional: true
  has_many :albums, dependent: :destroy
  has_one_attached :profile_picture

  validates :name, presence: true

  scope :listed, -> { where.associated(:albums).where('albums.publication_status': :published).distinct }

  after_update :transcode_albums, if: :metadata_changed?

  def listed?
    albums.where(publication_status: :published).any?
  end

  def transcode_albums
    albums.each(&:transcode_tracks)
  end

  def metadata_changed?
    name_previously_changed?
  end
end
