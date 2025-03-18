# frozen_string_literal: true

class StripeService
  include Rails.application.routes.url_helpers

  def initialize(purchase, stripe_connect_account)
    @purchase = purchase
    @stripe_connect_account = stripe_connect_account
  end

  def line_items
    items = [
      {
        price_data: {
          currency: 'gbp',
          unit_amount: @purchase.price_excluding_gratuity_in_pence,
          product_data: {
            name: @purchase.album.title,
            description: "#{@purchase.album.title} by #{@purchase.album.artist.name}",
            metadata: {
              productId: @purchase.album.id
            }
          }
        },
        quantity: 1
      }
    ]

    return items unless @purchase.gratuity?

    items << {
      price_data: {
        currency: 'gbp',
        unit_amount: @purchase.gratuity_in_pence,
        product_data: {
          name: 'Extra contribution',
          tax_code: 'txcd_90020001'
        }
      },
      quantity: 1
    }
  end

  def create_checkout_session
    session = Stripe::Checkout::Session.create(checkout_params, checkout_options)

    StripeServiceResponse.new(
      status: 'ok',
      error: nil,
      url: session.url,
      id: session.id
    )
  rescue StandardError => e
    StripeServiceResponse.new(
      status: 'error',
      error: e.message
    )
  end

  StripeServiceResponse = Struct.new(:status, :error, :url, :id, keyword_init: true) do
    def success?
      status == 'ok'
    end
  end

  private

  def checkout_params
    {
      success_url: purchase_url(@purchase),
      cancel_url: artist_album_url(@purchase.album.artist, @purchase.album),
      payment_method_types: ['card'],
      client_reference_id: @purchase.album.id,
      allow_promotion_codes: false,
      mode: 'payment',
      automatic_tax: { enabled: true },
      line_items:
    }.merge(payment_intent_data:)
  end

  def payment_intent_data
    return {} unless @stripe_connect_account.accepts_payments?

    { application_fee_amount: @purchase.platform_fee_in_pence }
  end

  def checkout_options
    return {} unless @stripe_connect_account.accepts_payments?

    { stripe_account: @stripe_connect_account.stripe_identifier }
  end
end
