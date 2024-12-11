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
    @album.unpublish
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

  test '#show when the album is not published has no publish button in the navbar' do
    @album.unpublish
    get artist_album_url(@album.artist, @album)

    assert_select 'nav' do
      assert_select 'button', text: 'Publish', count: 0
    end
  end

  test '#show shows the release date of the album' do
    @album.update(released_on: Date.parse('2023-06-20'))

    get artist_album_url(@album.artist, @album)

    assert_select 'p', 'released June 20, 2023'
  end

  test '#new' do
    get new_artist_album_url(@album.artist)
    assert_response :success
  end

  test '#create' do
    assert_difference('Album.count') do
      post artist_albums_url(@album.artist), params: {
        album: { title: 'Example', cover: fixture_file_upload('cover.png') }
      }
    end

    assert_redirected_to artist_album_url(@album.artist, Album.last)
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

  test '#publish sends an email to the artist' do
    assert_enqueued_email_with AlbumMailer, :published, params: { album: @album } do
      patch publish_artist_album_url(@album.artist, @album)
    end
  end

  test '#publish does not succeed if album has validation errors' do
    @album.tracks.destroy_all
    patch publish_artist_album_url(@album.artist, @album)
    assert_not @album.reload.published?
  end

  test '#publish redirects back to album page with error message if album has validation errors' do
    @album.tracks.destroy_all
    patch publish_artist_album_url(@album.artist, @album)
    assert_redirected_to artist_album_url(@album.artist, @album)
    assert_equal 'Errors prohibited this album from being saved: Number of tracks must be greater than 0', flash[:alert]
  end

  test '#publish does not send email to artist if album has validation errors' do
    @album.tracks.destroy_all
    assert_enqueued_emails 0 do
      patch publish_artist_album_url(@album.artist, @album)
    end
  end

  test '#unpublish' do
    patch unpublish_artist_album_url(@album.artist, @album)
    assert_redirected_to artist_album_url(@album.artist, @album)
    @album.reload
    assert_not @album.published?
  end
end

class AlbumsControllerTestSignedInAsArtist < ActionDispatch::IntegrationTest
  setup do
    @album = create(:published_album)
    user = create(:user)
    user.artists << @album.artist
    log_in_as(user)
  end

  test '#show when the album is not published has a publish button in the navbar' do
    @album.unpublish
    get artist_album_url(@album.artist, @album)

    assert_select 'nav' do
      assert_select 'button', text: 'Publish'
    end
  end

  test '#show when the album is pending publication has a disabled pending publication button in the navbar' do
    @album.pending
    get artist_album_url(@album.artist, @album)

    assert_select 'nav' do
      assert_select 'button[disabled=disabled]', text: 'Pending publication'
    end
  end

  test '#request_publication sets the pending state of the album' do
    patch request_publication_artist_album_url(@album.artist, @album)
    assert_redirected_to artist_album_url(@album.artist, @album)
    @album.reload
    assert @album.pending?
  end

  test '#request_publication sends an email to notify admins that artist has requested publication' do
    assert_enqueued_email_with AlbumMailer, :request_publication, params: { album: @album } do
      patch request_publication_artist_album_url(@album.artist, @album)
    end
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

  test '#publish' do
    patch publish_artist_album_url(@album.artist, @album)
    assert_redirected_to log_in_url
  end

  test '#unpublish' do
    patch unpublish_artist_album_url(@album.artist, @album)
    assert_redirected_to log_in_url
  end

  test '#request_publication' do
    patch request_publication_artist_album_url(@album.artist, @album)
    assert_redirected_to log_in_url
  end
end
