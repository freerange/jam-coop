# frozen_string_literal: true

class PurchaseMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def notify_artist
    user = build(:user)
    album = build(:album)
    user.artists << album.artist
    purchase = build(:purchase, album:, price: album.price)

    PurchaseMailer.with(purchase:).notify_artist
  end
end
