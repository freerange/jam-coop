# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTestSignedIn < ActionDispatch::IntegrationTest
  def setup
    @album = create(:album)
    sign_in_as(create(:user))
  end

  test '#show' do
    get artist_album_url(@album.artist, @album)
    assert_response :success
  end

  test '#show shows the published state of the album' do
    @album.update(published: false)
    get artist_album_url(@album.artist, @album)
    assert_select 'p', 'This album is currently unpublished'

    @album.update(published: true)
    get artist_album_url(@album.artist, @album)
    assert_select 'p', 'This album is currently published'
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
    assert_redirected_to artist_url(@album.artist)
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
