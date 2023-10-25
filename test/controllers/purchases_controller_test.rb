# frozen_string_literal: true

require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test 'show' do
    get purchase_url(create(:purchase))
    assert_response :success
  end

  test 'should get new' do
    album = create(:album)

    get new_artist_album_purchase_url(album.artist, album)

    assert_response :success
  end

  test 'create redirects to stripe if checkout session successfully created' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_url(album.artist, album)

    assert_redirected_to 'https://stripe.example.com'
  end

  test 'create redirects to purchase path if checkout session not successfully created' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: false, error: 'error message'))
    StripeService.expects(:new).returns(service)

    post artist_album_purchases_url(album.artist, album)

    assert_equal 'error message', flash[:alert]
    assert_redirected_to new_artist_album_purchase_url(album.artist, album)
  end

  test 'create creates a new purchase' do
    album = create(:album)
    service = stub(create_checkout_session: stub(success?: true, url: 'https://stripe.example.com'))
    StripeService.expects(:new).returns(service)

    assert_difference('Purchase.count') do
      post artist_album_purchases_url(album.artist, album)
    end
  end
end
