# frozen_string_literal: true

require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    sign_in_as(@user)
  end

  test 'should get new' do
    album = create(:album)

    get new_artist_album_purchase_url(album.artist, album)

    assert_response :success
  end

  test 'create redirects to stripe if checkout session successfully created' do
    album = create(:album)
    StripeService
      .expects(:create_checkout_session)
      .with(
        @user,
        album,
        success_url: artist_album_url(album.artist, album),
        cancel_url: artist_album_url(album.artist, album)
      ).returns(stub(success?: true, url: 'https://stripe.example.com'))

    post artist_album_purchases_url(album.artist, album)

    assert_redirected_to 'https://stripe.example.com'
  end

  test 'create redirects to purchase path if checkout session not successfully created' do
    album = create(:album)
    StripeService.expects(:create_checkout_session).returns(stub(success?: false, error: 'error message'))

    post artist_album_purchases_url(album.artist, album)

    assert_equal 'error message', flash[:alert]
    assert_redirected_to new_artist_album_purchase_url(album.artist, album)
  end
end
