# frozen_string_literal: true

class Label < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged
  belongs_to :user
  has_one_attached :logo
  has_many :releases, dependent: :destroy
  has_many :albums, through: :releases

  validates :name, presence: true
  validates(
    :logo,
    attached: { message: 'file cannot be missing' },
    content_type: {
      in: %w[image/jpeg image/png],
      message: 'must be an image file (jpeg, png)'
    }
  )
end
