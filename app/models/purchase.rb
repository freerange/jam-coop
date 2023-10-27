# frozen_string_literal: true

class Purchase < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :album

  validates :price, presence: true, numericality: true
  validate :price_is_greater_than_album_price, unless: -> { price.blank? }

  def price_in_pence
    (price * 100).to_i
  end

  private

  def price_is_greater_than_album_price
    return true if price >= album.price

    errors.add(:price, "Price must be more than #{number_to_currency(album.price, unit: '£')}")
  end
end
