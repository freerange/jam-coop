# frozen_string_literal: true

class StripeWebhookEventsController < ApplicationController
  ENDPOINT_SECRET = Rails.configuration.stripe[:endpoint_secret]

  skip_forgery_protection
  skip_before_action :authenticate

  def create
    skip_authorization
    payload = request.body.read
    sig_header = request.headers['Stripe-Signature']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENDPOINT_SECRET
      )
    rescue JSON::ParserError
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.debug { "Error verifying webhook signature: #{e.message}" }
      head :bad_request
      return
    end

    case event.type
    when 'checkout.session.completed'
      stripe_session_id = event.data.object.id
      PurchaseCompleteJob.perform_later(stripe_session_id)
    when 'account.updated'
      account_in_stripe = event.data.object
      account_in_jam = StripeAccount.find_by!(stripe_identifier: account_in_stripe.id)
      account_in_jam.update!(
        details_submitted: account_in_stripe.details_submitted?,
        charges_enabled: account_in_stripe.charges_enabled?
      )
    else
      Rails.logger.debug { "Unhandled event type: #{event.type}" }
    end

    head :created
  end
end
