# frozen_string_literal: true

require 'test_helper'

module Admin
  class AlbumsControllerTestSignedInAsAdmin < ActionDispatch::IntegrationTest
    def setup
      @album = create(:album, :with_tracks)
      @user = create(:user, admin: true)
      log_in_as(@user)
    end

    test '#show' do
      get admin_artist_album_path(@album.artist, @album)
      assert_response :success
    end

    test '#new' do
      get new_admin_artist_album_path(@album.artist)
      assert_response :success
    end

    test '#create' do
      assert_difference('Album.count') do
        post admin_artist_albums_path(@album.artist), params: {
          album: {
            title: 'Example',
            cover: fixture_file_upload('cover.png'),
            license_id: License.first.id,
            terms_of_use: true,
            ai_policy: true
          }
        }
      end

      assert_redirected_to admin_artist_album_path(@album.artist, Album.last)
    end

    test '#edit' do
      get edit_admin_artist_album_path(@album.artist, @album)
      assert_response :success
    end

    test '#update' do
      patch admin_artist_album_path(@album.artist, @album), params: { album: { title: 'Example' } }
      assert_redirected_to admin_artist_album_path(@album.artist, @album)
    end
  end

  class AlbumsControllerTestSignedOut < ActionDispatch::IntegrationTest
    test '#show' do
      get admin_artist_album_path(album.artist, album)
      assert_redirected_to log_in_path
    end

    test '#new' do
      get new_admin_artist_album_path(album.artist)
      assert_redirected_to log_in_path
    end

    test '#create' do
      post admin_artist_albums_path(album.artist), params: { album: { title: 'Example' } }
      assert_redirected_to log_in_path
    end

    test '#edit' do
      get edit_admin_artist_album_path(album.artist, album)
      assert_redirected_to log_in_path
    end

    test '#update' do
      patch admin_artist_album_path(album.artist, album), params: { album: { title: 'Example' } }
      assert_redirected_to log_in_path
    end

    private

    def album
      @album ||= create(:published_album)
    end
  end
end
