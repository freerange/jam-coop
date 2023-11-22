# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTestSignedIn < ActionDispatch::IntegrationTest
  def setup
    @album = create(:album)
    sign_in_as(create(:user, admin: true))
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
    @album.unpublish
    get artist_album_url(@album.artist, @album)
    assert_select 'button[disabled=disabled]', text: 'Buy'
  end

  test '#show shows the transcode state of each track' do
    track = create(:track, album: @album)
    create(:transcode, track:, format: :mp3v0)

    get artist_album_url(@album.artist, @album)

    assert_select 'li', "#{track.title} mp3v0"
  end

  test '#show shows the release date of the album' do
    @album.update(released_at: Date.parse('2023-06-20'))

    get artist_album_url(@album.artist, @album)

    assert_select 'p', 'released June 20, 2023'
  end

  test '#new' do
    get new_artist_album_url(@album.artist)
    assert_response :success
  end

  test '#create' do
    assert_difference('Album.count') do
      post artist_albums_url(@album.artist), params: { album: { title: 'Example' } }
    end

    assert_redirected_to artist_url(@album.artist)
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

  test '#publish' do
    patch publish_artist_album_url(@album.artist, @album)
    assert_redirected_to artist_album_url(@album.artist, @album)
    @album.reload
    assert @album.published?
  end

  test '#unpublish' do
    patch unpublish_artist_album_url(@album.artist, @album)
    assert_redirected_to artist_album_url(@album.artist, @album)
    @album.reload
    assert_not @album.published?
  end
end

class AlbumsControllerTestSignedOut < ActionDispatch::IntegrationTest
  def setup
    @album = create(:album)
  end

  test '#show' do
    get artist_album_url(@album.artist, @album)
    assert_response :success
  end

  test '#show does not indicate published state' do
    get artist_album_url(@album.artist, @album)
    assert_select 'p', text: 'This album is currently unpublished', count: 0
  end

  test '#new' do
    get new_artist_album_url(@album.artist)
    assert_redirected_to sign_in_url
  end

  test '#create' do
    post artist_albums_url(@album.artist), params: { album: { title: 'Example' } }
    assert_redirected_to sign_in_url
  end

  test '#edit' do
    get edit_artist_album_url(@album.artist, @album)
    assert_redirected_to sign_in_url
  end

  test '#update' do
    patch artist_album_url(@album.artist, @album), params: { album: { title: 'Example' } }
    assert_redirected_to sign_in_url
  end

  test '#publish' do
    patch publish_artist_album_url(@album.artist, @album)
    assert_redirected_to sign_in_url
  end

  test '#unpublish' do
    patch unpublish_artist_album_url(@album.artist, @album)
    assert_redirected_to sign_in_url
  end
end
