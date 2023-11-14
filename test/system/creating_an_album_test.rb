# frozen_string_literal: true

require 'application_system_test_case'

class CreatingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @artist = create(:artist)
    user = create(:user, artists: [@artist])

    sign_in_as(user)
  end

  test 'creating an album' do
    visit artist_url(@artist)
    click_link 'Add album'
    fill_in 'Title', with: "A Hard Day's Night"
    attach_file 'Cover', Rails.root.join('test/fixtures/files/cover.png')

    within('#tracks') do
      click_link 'Add track'
      fill_in 'Title', with: 'And I Love Her'
      attach_file 'File', Rails.root.join('test/fixtures/files/track.wav')
    end

    click_button 'Save'

    assert_text "A Hard Day's Night (unpublished)"
    click_link "A Hard Day's Night (unpublished)"
    assert_text '1. And I Love Her'
  end

  test 'editing an album' do
    album = create(:album, artist: @artist)

    visit artist_album_url(@artist, album)
    assert_text album.title
    click_link 'Edit album'
    fill_in 'Title', with: 'New Title'
    click_button 'Save'
    assert_text 'New Title'
  end
end
