# frozen_string_literal: true

class Label < ApplicationRecord
  extend FriendlyId
  include AttachmentMethods

  friendly_id :name, use: %i[slugged finders]
  belongs_to :user
  has_one_attached :logo
  has_many :releases, dependent: :destroy
  has_many :albums, through: :releases, inverse_of: :label

  validates :name, presence: true
  validates_image :logo, required: true
end
