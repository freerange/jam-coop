# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/notify_artist
  def notify_artist
    seller = build(:user)
    album = build(:album)
    seller.artists << album.artist
    purchase = build(:purchase, album:, price: album.price)

    PurchaseMailer.with(purchase:).notify_artist
  end
end
