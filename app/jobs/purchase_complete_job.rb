# frozen_string_literal: true

class PurchaseCompleteJob < ApplicationJob
  queue_as :default

  def perform(stripe_session_id)
    stripe_session = Stripe::Checkout::Session.retrieve(stripe_session_id)
    customer_email = stripe_session.customer_details.email
    amount_tax = stripe_session.total_details.amount_tax

    purchase = Purchase.find_by!(stripe_session_id:)
    return if purchase.completed?

    purchase.update(completed: true, customer_email:, amount_tax:)
    purchase.update(user: User.find_by(email: customer_email)) unless purchase.user

    PurchaseMailer.with(purchase:).completed.deliver_later

    if (payment_intent_id = stripe_session.payment_intent)
      payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
      if payment_intent.transfer_data.present?
        payout = purchase.seller.payouts.create!(
          payout_type: Payout::STRIPE_TYPE,
          transaction_reference: payment_intent_id,
          destination_reference: payment_intent.transfer_data.destination,
          amount_in_pence: payment_intent.transfer_data.amount,
          platform_fee_in_pence: payment_intent.metadata.application_fee_amount
        )
        purchase.update!(payout:)
      end
    end

    PurchaseMailer.with(purchase:).notify_artist.deliver_later
  end
end
