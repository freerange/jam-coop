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
end

class AlbumsControllerTestSignedOut < ActionDispatch::IntegrationTest
  def setup
    @album = create(:album)
  end

  test '#show' do
    get artist_album_url(@album.artist, @album)
    assert_response :success
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
end
