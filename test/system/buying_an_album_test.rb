# frozen_string_literal: true

require 'application_system_test_case'

class BuyingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:published_album, :with_tracks)
    create(:transcode, track: @album.tracks.first)
    stub_stripe_checkout_session
  end

  test 'purchasing an album' do
    visit artist_album_url(@album.artist, @album)
    click_on 'Buy'
    fill_in 'Price', with: @album.price
    click_on 'Checkout'

    perform_enqueued_jobs

    # Fake the Stripe checkout redirect to the "success_url"
    visit purchase_url(Purchase.last)
    assert_text 'Thank you!'
    assert_text 'Download (mp3v0)'
  end
end
