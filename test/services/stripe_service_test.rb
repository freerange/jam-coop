# frozen_string_literal: true

require 'test_helper'

class StripeServiceTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  def setup
    @purchase = build_stubbed(:purchase)
    @stripe_connect_account = build(:stripe_connect_account)
  end

  test 'creates Stripe checkout session with provided success_url' do
    Stripe::Checkout::Session.expects(:create).with(
      has_entry(success_url: purchase_url(@purchase)),
      anything
    )

    StripeService.new(@purchase, @stripe_connect_account).create_checkout_session
  end

  test 'creates Stripe checkout session with cancel_url' do
    Stripe::Checkout::Session.expects(:create).with(
      has_entry(cancel_url: artist_album_url(@purchase.album.artist, @purchase.album)),
      anything
    )

    StripeService.new(@purchase, @stripe_connect_account).create_checkout_session
  end

  test 'creates Stripe checkout session using album id as client_reference_id' do
    Stripe::Checkout::Session.expects(:create).with(
      has_entry(client_reference_id: @purchase.album.id),
      anything
    )

    StripeService.new(@purchase, @stripe_connect_account).create_checkout_session
  end

  test 'creates Stripe checkout session with Stripe account if it accepts payments' do
    @stripe_connect_account = create(:stripe_connect_account, charges_enabled: true)

    Stripe::Checkout::Session.expects(:create).with(
      anything,
      has_entry(stripe_account: @stripe_connect_account.stripe_identifier)
    )

    StripeService.new(@purchase, @stripe_connect_account).create_checkout_session
  end

  test 'creates Stripe checkout session with application fee amount if Stripe account accepts payments' do
    @stripe_connect_account = create(:stripe_connect_account, charges_enabled: true)

    Stripe::Checkout::Session.expects(:create).with(
      has_entry(payment_intent_data: { application_fee_amount: @purchase.platform_fee_in_pence }),
      anything
    )

    StripeService.new(@purchase, @stripe_connect_account).create_checkout_session
  end

  test 'creates Stripe checkout session without Stripe account if it does not accept payments' do
    @stripe_connect_account = create(:stripe_connect_account, charges_enabled: false)

    Stripe::Checkout::Session.expects(:create).with(
      Not(has_entry(payment_intent_data: { application_fee_amount: @purchase.platform_fee_in_pence })),
      anything
    )

    StripeService.new(@purchase, @stripe_connect_account).create_checkout_session
  end

  test 'creates Stripe checkout session without application fee amount if Stripe account does not accept payments' do
    @stripe_connect_account = create(:stripe_connect_account, charges_enabled: false)

    Stripe::Checkout::Session.expects(:create).with(
      Not(has_entry(application_fee_amount: @purchase.platform_fee_in_pence)),
      anything
    )

    StripeService.new(@purchase, @stripe_connect_account).create_checkout_session
  end

  test 'adds a product line item if the customer pays the suggested price' do
    album = build_stubbed(:album, price: 5.00)
    purchase = build_stubbed(:purchase, price: 5.00, album:)

    expected_line_item = {
      price_data: {
        currency: 'gbp',
        unit_amount: 500,
        product_data: {
          name: @purchase.album.title,
          description: "#{purchase.album.title} by #{purchase.album.artist.name}",
          metadata: {
            productId: purchase.album.id
          }
        }
      },
      quantity: 1
    }
    Stripe::Checkout::Session.expects(:create).with(
      has_entry(line_items: [expected_line_item]),
      anything
    )

    StripeService.new(purchase, @stripe_connect_account).create_checkout_session
  end

  test 'adds a product line item and a gratuity if the customer pays more than the suggested price' do
    album = build_stubbed(:album, price: 5.00)
    purchase = build_stubbed(:purchase, price: 8.00, album:)

    expected_purchase_line_item = {
      price_data: {
        currency: 'gbp',
        unit_amount: 500,
        product_data: {
          name: purchase.album.title,
          description: "#{purchase.album.title} by #{purchase.album.artist.name}",
          metadata: {
            productId: purchase.album.id
          }
        }
      },
      quantity: 1
    }

    expected_gratuity_line_item = {
      price_data: {
        currency: 'gbp',
        unit_amount: 300,
        product_data: {
          name: 'Extra contribution',
          tax_code: 'txcd_90020001'
        }
      },
      quantity: 1
    }
    Stripe::Checkout::Session.expects(:create).with(
      has_entry(line_items: [expected_purchase_line_item, expected_gratuity_line_item]),
      anything
    )

    StripeService.new(purchase, @stripe_connect_account).create_checkout_session
  end

  test 'returns an ok status if session created successfully' do
    Stripe::Checkout::Session.expects(:create).returns(
      stub(url: 'example.com', id: 'cs_test_foo')
    )

    response = StripeService.new(@purchase, @stripe_connect_account).create_checkout_session

    assert_equal 'ok', response.status
    assert_nil response.error
    assert_equal 'example.com', response.url
    assert_equal 'cs_test_foo', response.id
  end

  test 'returns an error status if session creation raises an error' do
    Stripe::Checkout::Session.expects(:create).raises(StandardError, 'message')

    response = StripeService.new(@purchase, @stripe_connect_account).create_checkout_session

    assert_equal 'error', response.status
    assert_equal 'message', response.error
  end
end
