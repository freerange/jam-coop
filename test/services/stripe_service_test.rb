# frozen_string_literal: true

require 'test_helper'

class StripeServiceTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  def setup
    album = create(:album)
    @purchase = create(:purchase, album:)
  end

  test 'creates stripe checkout session with provided success_url' do
    Stripe::Checkout::Session.expects(:create).with(has_entry(success_url: purchase_url(@purchase)))

    StripeService.new(@purchase).create_checkout_session
  end

  test 'creates stripe checkout session with cancel_url' do
    Stripe::Checkout::Session.expects(:create).with(
      has_entry(cancel_url: artist_album_url(@purchase.album.artist, @purchase.album))
    )

    StripeService.new(@purchase).create_checkout_session
  end

  test 'creates stripe checkout session using album id as client_reference_id' do
    Stripe::Checkout::Session.expects(:create).with(has_entry(client_reference_id: @purchase.album.id))

    StripeService.new(@purchase).create_checkout_session
  end

  test 'creates stripe checkout session with the correct line items' do
    expected_line_item = {
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
    Stripe::Checkout::Session.expects(:create).with(has_entry(line_items: [expected_line_item]))

    StripeService.new(@purchase).create_checkout_session
  end

  test 'returns an ok status if session created successfully' do
    Stripe::Checkout::Session.expects(:create).returns(stub(url: 'example.com'))

    response = StripeService.new(@purchase).create_checkout_session

    assert_equal 'ok', response.status
    assert_nil response.error
    assert_equal 'example.com', response.url
  end

  test 'returns an error status if session creation raises an error' do
    Stripe::Checkout::Session.expects(:create).raises(StandardError, 'message')

    response = StripeService.new(@purchase).create_checkout_session

    assert_equal 'error', response.status
    assert_equal 'message', response.error
  end
end
