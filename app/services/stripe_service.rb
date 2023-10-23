# frozen_string_literal: true

class StripeService
  def self.create_checkout_session(album, success_url:, cancel_url:)
    session = Stripe::Checkout::Session.create(
      {
        success_url:,
        cancel_url:,
        payment_method_types: ['card'],
        client_reference_id: album.id,
        allow_promotion_codes: false,
        mode: 'payment',
        line_items: [
          {
            price_data: {
              currency: 'gbp',
              unit_amount: 700,
              product_data: {
                name: album.title,
                description: "#{album.title} by #{album.artist.name}",
                metadata: {
                  productId: album.id
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
