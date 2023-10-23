# frozen_string_literal: true

class StripeService
  include Rails.application.routes.url_helpers

  def initialize(purchase, cancel_url:)
    @purchase = purchase
    @cancel_url = cancel_url
  end

  def create_checkout_session
    session = Stripe::Checkout::Session.create(
      {
        success_url: purchase_url(@purchase),
        cancel_url: @cancel_url,
        payment_method_types: ['card'],
        client_reference_id: @purchase.album.id,
        allow_promotion_codes: false,
        mode: 'payment',
        line_items: [
          {
            price_data: {
              currency: 'gbp',
              unit_amount: 700,
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
      }
    )

    StripeServiceResponse.new(
      status: 'ok',
      error: nil,
      url: session.url
    )
  rescue StandardError => e
    StripeServiceResponse.new(
      status: 'error',
      error: e.message
    )
  end

  StripeServiceResponse = Struct.new(:status, :error, :url, keyword_init: true) do
    def success?
      status == 'ok'
    end
  end
end
