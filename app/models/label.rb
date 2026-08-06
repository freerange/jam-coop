# frozen_string_literal: true

class Label < ApplicationRecord
  extend FriendlyId
  include AttachmentMethods

  friendly_id :name, use: :slugged
  belongs_to :user
  has_one_attached :logo
  has_many :releases, dependent: :destroy
  has_many :albums, through: :releases

  validates :name, presence: true
  validates_image :logo, required: true
end
