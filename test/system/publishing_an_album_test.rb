# frozen_string_literal: true

require 'application_system_test_case'

class PublishingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @album = create(:draft_album, :with_tracks)
    user = create(:user)
    user.artists << @album.artist
    log_in_as(user)
  end

  test 'publishing an album' do
    # Album appears in draft for this user on their artist page
    visit artist_path(@album.artist)
    assert_text @album.title
    assert_text 'draft'

    # Artist sets visibility of album to published
    visit artist_path(@album.artist)
    click_on @album.title.to_s
    click_on 'Edit'
    assert_checked_field 'Draft'
    choose 'Published'
    click_on 'Save'
    assert_text 'Artist was successfully updated'
    sign_out

    # Listener visits published album page
    visit artist_path(@album.artist)
    assert_text @album.title
    refute_text 'draft'
  end
end
