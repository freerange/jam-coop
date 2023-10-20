# frozen_string_literal: true

require 'application_system_test_case'

class BuyingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:album_with_tracks)
    create(:transcode, track: @album.tracks.first)
  end

  test 'purchasing an album' do
    visit artist_album_url(@album.artist, @album)
    click_button 'Buy'

    assert_selector 'button', text: 'Checkout'
  end
end
