# frozen_string_literal: true

class StripeWebhookEventsController < ApplicationController
  ENDPOINT_SECRET = Rails.application.credentials.dig(:stripe, :endpoint_secret)

  skip_forgery_protection
  skip_before_action :authenticate

  def create
    skip_authorization
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

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
      customer_email = event.data.object.customer_details.email
      purchase = Purchase.find_by!(stripe_session_id:)
      purchase.update(completed: true, customer_email:)
    else
      Rails.logger.debug { "Unhandled event type: #{event.type}" }
    end

    head :created
  end
end
