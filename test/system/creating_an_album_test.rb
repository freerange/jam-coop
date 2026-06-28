# frozen_string_literal: true

require 'application_system_test_case'

class CreatingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @artist = create(:artist)
    create(:license)
    @artist_user = create(:user, artists: [@artist])
  end

  test 'creating an album' do
    using_session 'artist' do
      log_in_as(@artist_user)
      visit edit_artist_path(@artist)
      click_on 'Add album'
      fill_in 'Title', with: "A Hard Day's Night"
      attach_file 'Cover', Rails.root.join('test/fixtures/files/cover.png')

      click_on 'Save'
      click_on 'Add track'

      assert_text 'New track'
      fill_in 'Title', with: 'And I Love Her'
      attach_file 'Upload file', Rails.root.join('test/fixtures/files/track.wav')
      click_on 'Save and add another'
      assert_text 'Track added'
      assert_text 'New track'
      fill_in 'Title', with: 'Eight days a week'
      attach_file 'Upload file', Rails.root.join('test/fixtures/files/track.wav')
      click_on 'Save'
      assert_text 'Track added'
      assert_text '1 And I Love Her'
      assert_text '2 Eight days a week'
    end

    perform_enqueued_jobs

    using_session 'admin' do
      # Admin checks transcodes
      admin = create(:user, admin: true, email: 'admin@example.com')
      log_in_as(admin)
      album = Album.find_by(title: "A Hard Day's Night")
      visit artist_album_path(album.artist, album)
      within(admin_section) do
        assert_text 'And I Love Her'
        assert_text 'mp3v0'
        assert_text 'mp3128k'
        assert_text 'flac'
      end
    end
  end

  test 'creating an album by uploading multiple wav files' do
    log_in_as(@artist_user)
    visit edit_artist_path(@artist)
    click_on 'Add album'
    fill_in 'Title', with: "A Hard Day's Night"
    attach_file 'Cover', Rails.root.join('test/fixtures/files/cover.png')

    click_on 'Save'
    click_on 'Add multiple tracks'

    assert_text 'Files must be in wav format'
    attach_file 'Upload file', [Rails.root.join('test/fixtures/files/one.wav'),
                                Rails.root.join('test/fixtures/files/two.wav'),
                                Rails.root.join('test/fixtures/files/three.wav')]
    click_on 'Save'
    assert_text 'Tracks added'

    assert_text '1 one'
    assert_text '2 two'
    assert_text '3 three'
  end

  test 'editing an album' do
    log_in_as(@artist_user)
    album = create(:album, artist: @artist)

    visit edit_artist_path(@artist, album)
    assert_text album.title
    click_on album.title
    within(details_section) do
      assert_text album.title
      click_on 'Edit details'
    end
    assert_text "Editing #{album.title}"
    fill_in 'Title', with: 'New Title'
    click_on 'Save'
    assert_text 'Album was successfully updated'
    assert_text 'New Title'
  end

  test 'editing a published album' do
    album = create(:published_album, artist: @artist)
    album.transcode_tracks

    perform_enqueued_jobs

    using_session 'listener' do
      visit artist_album_path(album.artist, album)

      album.tracks.each do |track|
        assert_has_playable_track(track)
      end
    end

    using_session 'artist' do
      track = album.tracks.first

      log_in_as(@artist_user)
      visit edit_artist_path(@artist)
      assert_text "Editing #{@artist.name}"
      assert_text album.title
      click_on album.title

      click_on track.title
      assert_text 'Edit track'

      within(details_section) do
        fill_in 'Title', with: 'Rename the first track'
      end

      click_on 'Save'
      assert_text 'Track updated'

      visit artist_album_path(album.artist, album)
      assert_text 'This album is published'
    end

    perform_enqueued_jobs

    using_session 'listener' do
      visit artist_album_path(album.artist, album)

      assert_text 'Rename the first track'

      album.tracks.each do |track|
        assert_has_playable_track(track.reload)
      end
    end
  end

  private

  def tracks_section
    find('h2', text: 'Tracks').ancestor('.sidebar-section')
  end

  def details_section
    find('h2', text: 'Details').ancestor('.sidebar-section')
  end

  def admin_section
    find('section', id: 'admin')
  end

  def assert_has_playable_track(track)
    assert_selector 'div[data-action="click->player#playTrack"] span', text: track.title
  end
end
