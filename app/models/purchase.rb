# frozen_string_literal: true

class Purchase < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :album
  belongs_to :user, optional: true
  has_many :purchase_downloads, dependent: :destroy

  validates :price, presence: true, numericality: true
  validate :price_is_greater_than_album_price, unless: -> { price.blank? }

  after_create :create_purchase_downloads

  def price_in_pence
    (price * 100).to_i
  end

  def price_excluding_gratuity_in_pence
    (album.price * 100).to_i
  end

  def gratuity?
    price > album.price
  end

  def gratuity_in_pence
    ((price - album.price) * 100).to_i
  end

  def suppress_sending?
    sending_suppressed_at.present?
  end

  def platform_fee_in_pence
    (price_in_pence * platform_fee_fraction).to_i
  end

  private

  def price_is_greater_than_album_price
    return true if price >= album.price

    errors.add(:price, "Price must be more than #{number_to_currency(album.price, unit: '£')}")
  end

  def create_purchase_downloads
    ZipDownloadJob.perform_later(self, format: :mp3v0)
    ZipDownloadJob.perform_later(self, format: :flac)
  end

  def platform_fee_fraction
    Rails.configuration.platform_fee_percentage / 100.0
  end
end
