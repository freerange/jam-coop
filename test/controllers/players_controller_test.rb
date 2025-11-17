# frozen_string_literal: true

require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @artist = create(:artist)
    @album = create(:album, :with_tracks, artist: @artist)
  end

  test '#show responds with 200 OK' do
    get artist_album_player_path(@artist, @album)
    assert_response :success
  end

  test '#show displays album artwork image' do
    get artist_album_player_path(@artist, @album)
    assert_select "img[alt='Album Cover']"
  end

  test '#show displays album title' do
    get artist_album_player_path(@artist, @album)
    assert_select 'h1', text: /#{@album.title}/
  end

  test '#show displays artist name' do
    get artist_album_player_path(@artist, @album)
    assert_select 'h1', text: /#{@artist.name}/
  end

  test '#show displays title of first track' do
    get artist_album_player_path(@artist, @album)
    assert_select 'h1', text: /#{@album.tracks.first.title}/
  end

  test '#show does not render hidden audio element when tracks have not been transcoded' do
    get artist_album_player_path(@artist, @album)
    refute_select 'audio.hidden'
  end

  test '#show renders hidden audio element when tracks have been transcoded' do
    perform_enqueued_jobs
    get artist_album_player_path(@artist, @album)
    assert_select 'audio.hidden'
  end

  test '#show allows page to be used in iframe on own site in newer browsers' do
    get artist_album_player_path(@artist, @album)
    assert_includes response.headers['Content-Security-Policy'], "'self'"
  end

  test '#show allows page to be used in iframe on https sites in newer browsers' do
    get artist_album_player_path(@artist, @album)
    assert_includes response.headers['Content-Security-Policy'], 'https:'
  end

  test '#show allows page to be used in iframe on any site in older browsers' do
    get artist_album_player_path(@artist, @album)
    assert_nil response.headers['X-Frame-Options']
  end
end
