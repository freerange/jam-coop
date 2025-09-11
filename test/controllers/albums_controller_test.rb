# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTestSignedInAsAdmin < ActionDispatch::IntegrationTest
  def setup
    @album = create(:album, :with_tracks)
    @user = create(:user, admin: true)
    log_in_as(@user)
  end

  test '#show' do
    get artist_album_url(@album.artist, @album)
    assert_response :success
  end

  test '#show shows a buy button when album is published' do
    @album.publish
    get artist_album_url(@album.artist, @album)
    assert_select 'button', text: 'Buy'
  end

  test '#show disables buy button when album is unpublished' do
    @album.unpublished!
    get artist_album_url(@album.artist, @album)
    assert_select 'button[disabled=disabled]', text: 'Buy'
  end

  test '#show shows download links instead of a buy button when album is purchased' do
    create(:purchase, album: @album, price: @album.price, user: @user)
    @album.publish

    get artist_album_url(@album.artist, @album)

    assert_select 'button', text: 'Buy', count: 0
    assert_select 'p', text: 'You own this album:'
  end

  test '#show shows the transcode state of each track' do
    track = create(:track, album: @album)
    create(:transcode, track:, format: :mp3v0)

    get artist_album_url(@album.artist, @album)

    assert_select 'li', "#{track.title} mp3v0"
  end

  test '#show shows the release date of the album' do
    @album.update(released_on: Date.parse('2023-06-20'))

    get artist_album_url(@album.artist, @album)

    assert_select 'p', 'Released: June 20, 2023'
  end

  test '#new' do
    get new_artist_album_url(@album.artist)
    assert_response :success
  end

  test '#create' do
    assert_difference('Album.count') do
      post artist_albums_url(@album.artist), params: {
        album: { title: 'Example', cover: fixture_file_upload('cover.png'), license_id: License.first.id }
      }
    end

    assert_redirected_to artist_album_url(@album.artist, Album.last)
  end

  test '#create enqueues transcoding' do
    assert_enqueued_with(job: TranscodeJob) do
      post artist_albums_url(@album.artist), params: {
        album: { title: 'Example',
                 cover: fixture_file_upload('cover.png'),
                 license_id: License.first.id,
                 tracks_attributes: { '0': { title: 'Test', original: fixture_file_upload('one.wav') } } }
      }
    end
  end

  test '#edit' do
    get edit_artist_album_url(@album.artist, @album)
    assert_response :success
  end

  test '#update' do
    patch artist_album_url(@album.artist, @album), params: { album: { title: 'Example' } }
    assert_redirected_to artist_album_url(@album.artist, @album)
  end

  test '#update accepts attributes for tracks' do
    track = create(:track, album: @album, title: 'Old name')

    patch artist_album_url(@album.artist, @album),
          params: { album: { title: 'Example', tracks_attributes: { id: track.id, title: 'New name' } } }

    assert_equal 'New name', track.reload.title
  end

  test '#update allows tracks to be destroyed' do
    track = create(:track, album: @album, title: 'Old name')

    assert_difference('Track.count', -1, 'A Track should be destroyed') do
      patch artist_album_url(@album.artist, @album),
            params: { album: { title: 'Example', tracks_attributes: { id: track.id, _destroy: true } } }
    end
  end
end

class AlbumsControllerTestSignedInAsArtist < ActionDispatch::IntegrationTest
  setup do
    @album = create(:published_album)
    user = create(:user)
    user.artists << @album.artist
    log_in_as(user)
  end

  test '#show has an edit button' do
    get artist_album_url(@album.artist, @album)

    assert_select 'a', text: 'Edit'
  end
end

class AlbumsControllerTestSignedOut < ActionDispatch::IntegrationTest
  def setup
    @album = create(:published_album)
  end

  test '#show' do
    get artist_album_url(@album.artist, @album)
    assert_response :success
  end

  test '#show does not indicate published state' do
    get artist_album_url(@album.artist, @album)
    assert_select 'p', text: 'This album is currently unpublished', count: 0
  end

  test '#show not authorized when album is unpublished' do
    @album = create(:unpublished_album)
    previous_url = artist_url(@album.artist)

    get artist_album_url(@album.artist, @album), headers: { 'HTTP_REFERER' => previous_url }

    assert_redirected_to previous_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test '#new' do
    get new_artist_album_url(@album.artist)
    assert_redirected_to log_in_url
  end

  test '#create' do
    post artist_albums_url(@album.artist), params: { album: { title: 'Example' } }
    assert_redirected_to log_in_url
  end

  test '#edit' do
    get edit_artist_album_url(@album.artist, @album)
    assert_redirected_to log_in_url
  end

  test '#update' do
    patch artist_album_url(@album.artist, @album), params: { album: { title: 'Example' } }
    assert_redirected_to log_in_url
  end
end
