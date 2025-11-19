# frozen_string_literal: true

require 'test_helper'

class FollowingsControllerTest < ActionDispatch::IntegrationTest
  test '#create redirects to login if no user logged in' do
    artist = create(:artist)

    post artist_following_path(artist)

    assert_redirected_to log_in_path
  end

  test "#create adds the user to the artist's followers" do
    user = create(:user)
    artist = create(:artist)
    log_in_as(user)

    post artist_following_path(artist)

    assert_equal [user], artist.followers
  end

  test '#create redirects to artist page' do
    user = create(:user)
    artist = create(:artist)
    log_in_as(user)

    post artist_following_path(artist)

    assert_redirected_to artist_path(artist)
  end

  test '#create sets a flash message' do
    user = create(:user)
    artist = create(:artist, name: 'artist-name')
    log_in_as(user)

    post artist_following_path(artist)

    assert_equal 'You are now following artist-name', flash[:notice]
  end

  test '#destroy redirects to login if no user logged in' do
    artist = create(:artist)

    delete artist_following_path(artist)

    assert_redirected_to log_in_path
  end

  test "#destroy removes the user from the artist's followers" do
    user = create(:user)
    artist = create(:artist)
    create(:following, user:, artist:)
    log_in_as(user)

    delete artist_following_path(artist)

    assert_equal [], artist.followers
  end

  test '#destroy redirects to artist page' do
    user = create(:user)
    artist = create(:artist)
    create(:following, user:, artist:)
    log_in_as(user)

    delete artist_following_path(artist)

    assert_redirected_to artist_path(artist)
  end

  test '#destroy sets a flash message' do
    user = create(:user)
    artist = create(:artist, name: 'artist-name')
    create(:following, user:, artist:)
    log_in_as(user)

    delete artist_following_path(artist)

    assert_equal 'You are no longer following artist-name', flash[:notice]
  end
end
