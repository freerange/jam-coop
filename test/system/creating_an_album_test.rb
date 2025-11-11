# frozen_string_literal: true

require 'application_system_test_case'

class CreatingAnAlbumTest < ApplicationSystemTestCase
  setup do
    @artist = create(:artist)
    create(:license)
    @artist_user = create(:user, artists: [@artist])
  end

  test 'creating an album' do
    log_in_as(@artist_user)
    visit edit_artist_url(@artist)
    click_on 'Add album'
    fill_in 'Title', with: "A Hard Day's Night"
    attach_file 'Cover', Rails.root.join('test/fixtures/files/cover.png')

    within(tracks_section) do
      click_on 'Add track'
      fill_in 'Title', with: 'And I Love Her'
      attach_file 'File', Rails.root.join('test/fixtures/files/track.wav')
    end

    click_on 'Save'

    assert_text "A Hard Day's Night"
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
    log_in_as(@artist_user)
    album = create(:album, artist: @artist)

    visit edit_artist_url(@artist, album)
    assert_text album.title
    click_on album.title
    fill_in 'Title', with: 'New Title'
    click_on 'Save'
    assert_text 'New Title'
  end

  test 'editing a published album' do
    album = create(:published_album, artist: @artist)
    album.transcode_tracks

    perform_enqueued_jobs

    using_session 'listener' do
      visit artist_album_url(album.artist, album)

      album.tracks.each do |track|
        assert_has_playable_track(track)
      end
    end

    using_session 'artist' do
      log_in_as(@artist_user)
      visit edit_artist_url(@artist)
      assert_text album.title
      click_on album.title

      within(tracks_section) do
        first_track = first('div[data-testid="track-data"]', minimum: 0)
        within(first_track) do
          fill_in 'Title', with: 'Rename the first track'
        end

        click_on 'Add track'

        new_track = all('div[data-testid="track-data"]', minimum: 0).last
        within(new_track) do
          fill_in 'Title', with: 'And I Love Her'
          attach_file 'File', Rails.root.join('test/fixtures/files/track.wav')
        end
      end

      click_on 'Save'
      assert_text 'This album is published'
    end

    perform_enqueued_jobs

    using_session 'listener' do
      visit artist_album_url(album.artist, album)

      assert_text 'Rename the first track'
      assert_text album.reload.tracks[1].title
      assert_text 'And I Love Her'

      album.tracks.each do |track|
        assert_has_playable_track(track)
      end
    end
  end

  private

  def tracks_section
    find('h2', text: 'Tracks').ancestor('.sidebar-section')
  end

  def admin_section
    find('section', id: 'admin')
  end

  def assert_has_playable_track(track)
    assert_selector 'div[data-action="click->player#playTrack"] span', text: track.title
  end
end
