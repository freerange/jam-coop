# frozen_string_literal: true

require 'application_system_test_case'

class BuyingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:album_with_tracks)
    create(:transcode, track: @album.tracks.first)
  end

  test 'viewing the album' do
    visit artists_url
    click_link @album.artist.name
    click_link @album.title

    assert_text "1. #{@album.tracks.first.title}"
    assert_text @album.about.gsub(/^\s+/, '')
    assert_text @album.credits.gsub(/^\s+/, '')
  end
end
