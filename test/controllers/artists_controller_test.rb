# frozen_string_literal: true

require 'test_helper'

class ArtistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = create(:artist)
  end

  test 'should get new' do
    get new_artist_url
    assert_response :success
  end

  test 'should create artist' do
    assert_difference('Artist.count') do
      post artists_url, params: { artist: { name: 'Example' } }
    end

    assert_redirected_to artist_url(Artist.last)
  end

  test 'should get edit' do
    get edit_artist_url(@artist)
    assert_response :success
  end

  test 'should update artist' do
    patch artist_url(@artist), params: { artist: { name: 'New name' } }
    assert_redirected_to artist_url(@artist)
  end

  test 'should destroy artist' do
    assert_difference('Artist.count', -1) do
      delete artist_url(@artist)
    end

    assert_redirected_to artists_url
  end
end
