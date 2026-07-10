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

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/notify_artist_with_stripe_payout
  def notify_artist_with_stripe_payout
    seller = build(:user)
    stripe_payout = build(:stripe_payout)
    purchase = build_stubbed(:purchase, payout: stripe_payout)
    purchase.define_singleton_method(:seller) { seller }

    PurchaseMailer.with(purchase:).notify_artist
  end

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/notify_artist_with_stripe_account_not_accepting_payments
  def notify_artist_with_stripe_account_not_accepting_payments
    stripe_connect_account = build(:stripe_connect_account)
    seller = build(:user, stripe_connect_account:)
    purchase = build_stubbed(:purchase)
    purchase.define_singleton_method(:seller) { seller }

    PurchaseMailer.with(purchase:).notify_artist
  end

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/notify_artist_without_stripe_account_but_with_payout_detail
  def notify_artist_without_stripe_account_but_with_payout_detail
    payout_detail = build(:payout_detail)
    seller = build(:user, payout_detail:)
    purchase = build_stubbed(:purchase)
    purchase.define_singleton_method(:seller) { seller }

    PurchaseMailer.with(purchase:).notify_artist
  end
end
