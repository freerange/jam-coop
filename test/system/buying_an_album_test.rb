# frozen_string_literal: true

require 'application_system_test_case'

class BuyingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:album)
  end

  test 'viewing the album' do
    visit album_url(@album)
    assert_selector 'h1', text: @album.title
    assert_selector 'h2', text: @album.artist.name
  end
end
