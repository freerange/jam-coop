# frozen_string_literal: true

require 'test_helper'

class ArtistsControllerTestSignedIn < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(create(:user, admin: true))
    @artist = create(:artist)
  end

  test '#index' do
    get artists_url
    assert_response :success
  end

  test '#index should show both listed and unlisted artist' do
    get artists_url
    assert_select 'p', @artist.name

    @artist.update(listed: false)

    get artists_url
    assert_select 'p', "#{@artist.name} (unlisted)"
  end

  test '#show' do
    get artist_url(@artist)
    assert_response :success
  end

  test '#new' do
    get new_artist_url
    assert_response :success
  end

  test '#create' do
    assert_difference('Artist.count') do
      post artists_url, params: { artist: { name: 'Example' } }
    end

    assert_redirected_to artist_url(Artist.last)
  end

  test '#edit' do
    get edit_artist_url(@artist)
    assert_response :success
  end

  test '#update' do
    patch artist_url(@artist), params: { artist: { name: 'New name' } }
    assert_redirected_to artist_url(@artist)
  end

  test '#destroy' do
    assert_difference('Artist.count', -1) do
      delete artist_url(@artist)
    end

    assert_redirected_to artists_url
  end
end

class ArtistsControllerTestSignedOut < ActionDispatch::IntegrationTest
  setup do
    @artist = create(:artist)
  end

  test '#index' do
    get artists_url
    assert_response :success
  end

  test '#index should only show listed artists' do
    get artists_url
    assert_select 'p', @artist.name

    @artist.update(listed: false)

    get artists_url
    assert_select 'p', { count: 0, text: @artist.name }
  end

  test '#show' do
    get artist_url(@artist)
    assert_response :success
  end

  test '#new' do
    get new_artist_url
    assert_redirected_to sign_in_path
  end

  test '#create' do
    post artists_url, params: { artist: { name: 'Example' } }
    assert_redirected_to sign_in_path
  end

  test '#edit' do
    get edit_artist_url(@artist)
    assert_redirected_to sign_in_path
  end

  test '#update' do
    patch artist_url(@artist), params: { artist: { name: 'New name' } }
    assert_redirected_to sign_in_path
  end

  test '#destroy' do
    delete artist_url(@artist)

    assert_redirected_to sign_in_path
  end
end
