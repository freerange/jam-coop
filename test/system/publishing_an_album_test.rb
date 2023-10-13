# frozen_string_literal: true

require 'application_system_test_case'

class PublishingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:album, published: false)
    sign_in_as(create(:user))
  end

  test 'publishing an album' do
    visit artists_url
    click_link @album.artist.name
    click_link "#{@album.title} (unpublished)"

    click_button 'Publish'

    visit artists_url
    click_link @album.artist.name

    assert_text @album.title
  end
end
