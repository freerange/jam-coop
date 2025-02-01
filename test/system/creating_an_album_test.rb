# frozen_string_literal: true

require 'application_system_test_case'

class CreatingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @artist = create(:artist)
    user = create(:user, artists: [@artist])

    log_in_as(user)
  end

  test 'creating an album' do
    visit edit_artist_url(@artist)
    click_on 'Add album'
    fill_in 'Title', with: "A Hard Day's Night"
    attach_file 'Cover', Rails.root.join('test/fixtures/files/cover.png')

    within(tracks_section) do
      click_on 'Add track'
      fill_in 'Title', with: 'And I Love Her'
      attach_file 'File', Rails.root.join('test/fixtures/files/track.wav')
    end

    click_on 'Save & preview'

    assert_text "A Hard Day's Night"
    find('button', text: 'Publish')
    sign_out

    perform_enqueued_jobs

    # Admin checks transcodes
    admin = create(:user, admin: true, email: 'admin@example.com')
    log_in_as(admin)
    album = Album.find_by(title: "A Hard Day's Night")
    visit artist_album_url(album.artist, album)
    within(admin_section) do
      assert_text 'And I Love Her'
      assert_text 'mp3v0'
      assert_text 'mp3128k'
      assert_text 'flac'
    end
  end

  test 'editing an album' do
    album = create(:album, artist: @artist)

    visit edit_artist_url(@artist, album)
    assert_text album.title
    click_on album.title
    fill_in 'Title', with: 'New Title'
    click_on 'Save & preview'
    assert_text 'New Title'
  end

  private

  def tracks_section
    find('h2', text: 'Tracks').ancestor('.sidebar-section')
  end

  def admin_section
    find('section', id: 'admin')
  end
end
