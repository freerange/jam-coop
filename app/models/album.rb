# frozen_string_literal: true

class Album < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :artist

  validates :title, presence: true

  belongs_to :artist
  has_many :tracks, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :album

  has_one_attached :cover
end
