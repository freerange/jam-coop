# frozen_string_literal: true

class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
  validates :musicbrainz_id, uniqueness: { allow_blank: true }

  has_many :taggings, dependent: :destroy
  has_many :albums, through: :taggings

  def to_s
    name
  end
end
