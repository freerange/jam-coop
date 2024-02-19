# frozen_string_literal: true

require 'application_system_test_case'

class ManagingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @artist = create(:artist)
    user = create(:user, artists: [@artist])
    create_list(:license, 2)

    log_in_as(user)
  end

  test 'creating an album' do
    license_select_first = License.first.label
    license_select_second = License.second.label
    visit artist_url(@artist)
    click_link 'Add album'
    fill_in 'Title', with: "A Hard Day's Night"
    attach_file 'Cover', Rails.root.join('test/fixtures/files/cover.png')
    fill_in 'Released on', with: '2024/01/30'
    select license_select_first, from: 'album_license_id'

    within('#tracks') do
      click_link 'Add track'
      fill_in 'Title', with: 'And I Love Her'
      attach_file 'File', Rails.root.join('test/fixtures/files/track.wav')
    end

    click_button 'Save'

    assert_text "A Hard Day's Night (unpublished)"
    click_link "A Hard Day's Night (unpublished)"
    assert_text '1. And I Love Her'

    click_link 'Edit album'
    fill_in 'Title', with: 'New Title', id: 'album_title'
    select license_select_second, from: 'album_license_id'

    click_button 'Save'

    assert_text 'New Title'
    assert_text license_select_second
  end
end
