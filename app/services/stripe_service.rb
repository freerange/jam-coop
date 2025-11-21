# frozen_string_literal: true

class StripeService
  include Rails.application.routes.url_helpers

  def initialize(purchase)
    @purchase = purchase
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
    session = Stripe::Checkout::Session.create(checkout_params)

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
    }
  end
end
