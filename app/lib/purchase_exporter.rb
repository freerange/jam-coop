# frozen_string_literal: true

require 'csv'

class PurchaseExporter
  def initialize(date = Time.zone.today)
    @date = date
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w[purchase_id purchase_price purchase_amount_tax user_email
                payout_name payout_country album_title artist_name]

      purchases.each do |purchase|
        csv << [
          purchase.id,
          (purchase.price * 100).to_i,
          purchase.amount_tax,
          purchase.seller.email,
          purchase.seller.payout_detail&.name,
          purchase.seller.payout_detail&.country,
          purchase.album.title,
          purchase.album.artist.name
        ]
      end
    end
  end

  private

  def purchases
    Purchase
      .where(created_at: @date.last_month.beginning_of_month...@date.beginning_of_month)
      .where(completed: true)
      .without_payout
  end
end
