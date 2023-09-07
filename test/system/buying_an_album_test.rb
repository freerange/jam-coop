# frozen_string_literal: true

require 'application_system_test_case'

class BuyingAnAlbumTest < ApplicationSystemTestCase
  setup do
    sign_in_as(create(:user))
    @album = create(:album_with_tracks)
  end

  test 'viewing the album' do
    visit artist_album_url(@album.artist, @album)
    assert_selector 'h1', text: @album.title
    assert_selector 'h2', text: @album.artist.name

    assert_text "1. #{@album.tracks.first.title}"
  end
end
