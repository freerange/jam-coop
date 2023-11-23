# frozen_string_literal: true

require 'application_system_test_case'

class PublishingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:album, publication_status: :unpublished)
    user = create(:user)
    user.artists << @album.artist
    sign_in_as(user)
  end

  test 'publishing an album' do
    visit artist_url(@album.artist)
    click_link "#{@album.title} (unpublished)"

    click_button 'Publish'
    assert_text "Thank you! We'll email you when your album is published."
  end
end
