# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/completed
  def completed
    purchase = build_stubbed(:purchase, customer_email: 'customer@example.com')

    PurchaseMailer.with(purchase:).completed
  end

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/notify_artist
  def notify_artist
    seller = build(:user)
    purchase = build_stubbed(:purchase)
    purchase.define_singleton_method(:seller) { seller }

    PurchaseMailer.with(purchase:).notify_artist
  end
end
