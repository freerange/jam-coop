# frozen_string_literal: true

require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test 'show' do
    get purchase_path(create(:purchase))
    assert_response :success
  end

  test 'should get new' do
    album = create(:album)

    get new_artist_album_purchase_path(album.artist, album)

    assert_response :success
  end

  test 'create redirects to stripe if checkout session successfully created' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_path(album.artist, album),
         params: { purchase: { price: album.price, contact_opt_in: true } }

    assert_redirected_to 'https://stripe.example.com'
  end

  test 'create redirects to purchase path if checkout session not successfully created' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: false, error: 'error message'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_path(album.artist, album),
         params: { purchase: { price: album.price, contact_opt_in: true } }

    assert_equal 'error message', flash[:alert]
    assert_redirected_to new_artist_album_purchase_path(album.artist, album)
  end

  test 'create creates a new purchase' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)

    assert_difference('Purchase.count') do
      post artist_album_purchases_path(album.artist, album),
           params: { purchase: { price: album.price, contact_opt_in: true } }
    end
  end

  test 'create sets the contact_opt_in on the purchase' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_path(album.artist, album),
         params: { purchase: { price: album.price, contact_opt_in: true } }

    assert_equal true, Purchase.last.contact_opt_in
  end

  test 'create sets the stripe_session_id on the purchase' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_path(album.artist, album),
         params: { purchase: { price: album.price, contact_opt_in: true } }

    assert_equal 'cs_test_foo', Purchase.last.stripe_session_id
  end

  test 'create sets the user on the purchase' do
    user = create(:user)
    log_in_as(user)
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_path(album.artist, album),
         params: { purchase: { price: album.price, contact_opt_in: true } }

    assert_equal user, Purchase.last.user
  end

  test 'does not set the user when not logged in' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com', id: 'cs_test_foo'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_path(album.artist, album),
         params: { purchase: { price: album.price, contact_opt_in: true } }

    assert_nil Purchase.last.user
  end
end
