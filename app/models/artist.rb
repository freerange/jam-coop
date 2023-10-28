# frozen_string_literal: true

class Artist < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :albums, dependent: :destroy
  has_one_attached :profile_picture

  validates :name, presence: true

  scope :listed, -> { where(listed: true) }
end
