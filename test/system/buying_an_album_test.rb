# frozen_string_literal: true

require 'application_system_test_case'

class BuyingAnAlbumTest < ApplicationSystemTestCase
  setup do
    sign_in_as(create(:user))
    @album = create(:album_with_tracks)
    create(:transcode, track: @album.tracks.first)
  end

  test 'viewing the album' do
    visit artists_url
    click_on @album.artist.name
    click_on @album.title

    assert_selector 'h1', text: @album.title
    assert_selector 'h2', text: @album.artist.name

    assert_text "1. #{@album.tracks.first.title}"

    assert_text @album.about.gsub(/^\s+/, '')
    assert_text @album.credits.gsub(/^\s+/, '')
  end
end
