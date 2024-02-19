# frozen_string_literal: true

require 'application_system_test_case'

class EditingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @artist = create(:artist)
    user = create(:user, artists: [@artist])
    create_list(:license, 2)
    create(:album, artist: @artist, license: @license)

    log_in_as(user)
  end

  test 'editing an album' do
    license_label = License.second.label
    album = create(:album, artist: @artist)

    visit artist_album_url(@artist, album)
    assert_text album.title
    click_link 'Edit album'
    fill_in 'Title', with: 'New Title'
    select license_label, from: 'album_license_id'

    click_button 'Save'

    assert_text 'New Title'
    assert_text license_label
  end
end
