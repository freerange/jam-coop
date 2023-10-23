# frozen_string_literal: true

require 'test_helper'

class StripeServiceTest < ActiveSupport::TestCase
  def setup
    @album = create(:album)
  end

  test 'creates stripe checkout session with provided success_url' do
    Stripe::Checkout::Session.expects(:create).with(has_entry(success_url: 'example.com'))

    StripeService.create_checkout_session(@album, success_url: 'example.com', cancel_url: '')
  end

  test 'creates stripe checkout session with provided cancel_url' do
    Stripe::Checkout::Session.expects(:create).with(has_entry(cancel_url: 'example.com'))

    StripeService.create_checkout_session(@album, success_url: '', cancel_url: 'example.com')
  end

  test 'creates stripe checkout session using album id as client_reference_id' do
    Stripe::Checkout::Session.expects(:create).with(has_entry(client_reference_id: @album.id))

    StripeService.create_checkout_session(@album, success_url: '', cancel_url: '')
  end

  test 'creates stripe checkout session with the correct line items' do
    expected_line_item = {
      price_data: {
        currency: 'gbp',
        unit_amount: 700,
        product_data: {
          name: @album.title,
          description: "#{@album.title} by #{@album.artist.name}",
          metadata: {
            productId: @album.id
          }
        }
      },
      quantity: 1
    }
    Stripe::Checkout::Session.expects(:create).with(has_entry(line_items: [expected_line_item]))

    StripeService.create_checkout_session(@album, success_url: '', cancel_url: '')
  end

  test 'returns an ok status if session created successfully' do
    Stripe::Checkout::Session.expects(:create).returns(stub(url: 'example.com'))

    response = StripeService.create_checkout_session(@album, success_url: '', cancel_url: '')

    assert_equal 'ok', response.status
    assert_nil response.error
    assert_equal 'example.com', response.url
  end

  test 'returns an error status if session creation raises an error' do
    Stripe::Checkout::Session.expects(:create).raises(StandardError, 'message')

    response = StripeService.create_checkout_session(@album, success_url: '', cancel_url: '')

    assert_equal 'error', response.status
    assert_equal 'message', response.error
  end
end
