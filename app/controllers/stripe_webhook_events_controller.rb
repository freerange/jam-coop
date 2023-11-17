# frozen_string_literal: true

class StripeWebhookEventsController < ApplicationController
  skip_forgery_protection
  skip_before_action :authenticate

  def create
    skip_authorization
    payload = request.body.read

    begin
      event = Stripe::Event.construct_from(
        JSON.parse(payload, symbolize_names: true)
      )
    rescue JSON::ParserError
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
