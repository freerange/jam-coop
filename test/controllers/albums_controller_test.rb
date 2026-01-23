# frozen_string_literal: true

require 'test_helper'

class AlbumsControllerTestSignedInAsAdmin < ActionDispatch::IntegrationTest
  def setup
    @album = create(:album, :with_tracks)
    @user = create(:user, admin: true)
    log_in_as(@user)
  end

  test '#show' do
    get artist_album_path(@album.artist, @album)
    assert_response :success
  end

  test '#show shows a buy button when album is published' do
    @album.published!
    get artist_album_path(@album.artist, @album)
    assert_select 'button', text: 'Buy'
  end

  test '#show disables buy button when album is draft' do
    @album.draft!
    get artist_album_path(@album.artist, @album)
    assert_select 'button[disabled=disabled]', text: 'Buy'
  end

  test '#show shows download links instead of a buy button when album is purchased' do
    create(:purchase, album: @album, price: @album.price, user: @user)
    perform_enqueued_jobs
    @album.published!

    get artist_album_path(@album.artist, @album)

    assert_select 'button', text: 'Buy', count: 0
    assert_select 'p', text: 'You own this album:'
    assert_select 'a', text: 'Download (mp3v0)'
    assert_select 'a', text: 'Download (flac)'
  end

  test '#show shows the transcode state of each track' do
    track = create(:track, album: @album)
    create(:transcode, track:, format: :mp3v0)

    get artist_album_path(@album.artist, @album)

    assert_select 'li', "#{track.title} mp3v0"
  end

  test '#show shows the release date of the album' do
    @album.update(released_on: Date.parse('2023-06-20'))

    get artist_album_path(@album.artist, @album)

    assert_select 'p', 'Released: June 20, 2023'
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
    get artist_album_path(@album.artist, @album)

    assert_select 'a', text: 'Edit album'
  end

  test '#show indicates draft visibility of album' do
    @album.draft!
    get artist_album_path(@album.artist, @album)
    assert_match 'Only you can see it', response.body
  end

  test '#show indicates published visibility of album' do
    @album.published!
    get artist_album_path(@album.artist, @album)
    assert_match 'Everyone can see it', response.body
  end
end

class AlbumsControllerTestSignedOut < ActionDispatch::IntegrationTest
  test '#index' do
    get albums_path
    assert_response :success
  end

  test '#index with atom format should render atom feed' do
    artist = create(:artist, name: 'Artist Name')
    create(:published_album, title: 'Older Album', first_published_on: 3.days.ago, artist:)
    create(:published_album, title: 'Newer Album', first_published_on: 1.day.ago, artist:)
    create(:draft_album, title: 'Draft Album', artist:)

    get albums_path(format: :atom)

    feed = RSS::Parser.parse(response.body)
    assert_equal 'Albums on jam.coop', feed.title.content
    assert_equal 'Newer Album by Artist Name', feed.entries.first.title.content
    assert_equal 'Older Album by Artist Name', feed.entries.last.title.content
    assert_not_includes feed.entries.map(&:title).map(&:content), 'Draft Album by Artist Name'
  end

  test '#show' do
    get artist_album_path(album.artist, album)
    assert_response :success
  end

  test '#show not authorized when album is draft' do
    draft_album = create(:draft_album)
    previous_path = artist_path(draft_album.artist)

    get artist_album_path(draft_album.artist, draft_album), headers: { 'HTTP_REFERER' => previous_path }

    assert_redirected_to previous_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test '#show renders twitter:player meta tag' do
    get artist_album_path(album.artist, album)
    assert_select %(meta[name="twitter:player"][content="#{artist_album_player_url(album.artist, album)}"])
  end

  test '#show renders twitter:player:height meta tag' do
    get artist_album_path(album.artist, album)
    assert_select %(meta[name="twitter:player:height"][content="#{Rails.configuration.x.player.height}"])
  end

  test '#show renders twitter:player:width meta tag' do
    get artist_album_path(album.artist, album)
    assert_select %(meta[name="twitter:player:width"][content="#{Rails.configuration.x.player.width}"])
  end

  test '#random redirects to a random album' do
    album = create(:published_album)
    get random_albums_path
    assert_redirected_to artist_album_path(album.artist, album)
  end

  test '#random excludes unpublished albums' do
    create(:album)
    album = create(:published_album)
    get random_albums_path
    assert_redirected_to artist_album_path(album.artist, album)
  end

  private

  def album
    @album ||= create(:published_album)
  end
end
