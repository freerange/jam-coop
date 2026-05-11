# frozen_string_literal: true

class PurchaseCompleteJob < ApplicationJob
  queue_as :default

  def perform(stripe_session_id)
    stripe_session = Stripe::Checkout::Session.retrieve(stripe_session_id)
    customer_email = stripe_session.customer_details.email
    amount_tax = stripe_session.total_details.amount_tax

    purchase = Purchase.find_by!(stripe_session_id:)
    purchase.update(completed: true, customer_email:, amount_tax:)
    purchase.update(user: User.find_by(email: customer_email)) unless purchase.user

    PurchaseMailer.with(purchase:).completed.deliver_later

    payment_intent = Stripe::PaymentIntent.retrieve(stripe_session.payment_intent)
    if payment_intent.transfer_data.present?
      payout = purchase.seller.payouts.create!(
        payout_type: Payout::STRIPE_TYPE,
        transaction_reference: payment_intent.id,
        destination_reference: payment_intent.transfer_data.destination,
        amount_in_pence: payment_intent.amount,
        platform_fee_in_pence: payment_intent.application_fee_amount
      )
      purchase.update!(payout:)
    end

    PurchaseMailer.with(purchase:).notify_artist.deliver_later
  end
end
