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
    # Album does not appear in "recently released" section
    visit root_path
    within(recently_released) do
      refute_text @album.title
    end

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
    click_on @album.title

    # Album appears in "recently released" section
    visit root_path
    within(recently_released) do
      assert_text @album.title
    end
  end

  private

  def recently_released
    find('h2', text: 'Recently released').ancestor('section')
  end
end
