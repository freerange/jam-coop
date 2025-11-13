# frozen_string_literal: true

require 'test_helper'

class ArtistsControllerTestSignedIn < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, admin: true)
    log_in_as(@user)
    @artist = create(:artist)
  end

  test '#index' do
    get artists_path
    assert_response :success
  end

  test '#index should show both listed and unlisted artist' do
    get artists_path
    assert_select 'p', "#{@artist.name} (unlisted)"

    @artist.albums << create(:published_album)

    get artists_path
    assert_select 'p', @artist.name
  end

  test '#index with atom format should render atom feed' do
    @artist.update!(name: 'Older Artist')
    create(:published_album, artist: @artist, first_published_on: 3.days.ago)
    create(:draft_album, artist: @artist)

    another_artist = create(:artist, name: 'Newer Artist')
    create(:published_album, artist: another_artist, first_published_on: 1.day.ago)

    unlisted_artist = create(:artist, name: 'Unlisted Artist')
    create(:draft_album, artist: unlisted_artist)

    get artists_path(format: :atom)

    feed = RSS::Parser.parse(response.body)
    assert_equal 'Artists on jam.coop', feed.title.content
    assert_equal 'Newer Artist', feed.entries.first.title.content
    assert_equal 'Older Artist', feed.entries.last.title.content
    assert_not_includes feed.entries.map(&:title).map(&:content), 'Unlisted Artist'
  end

  test '#show should include published albums' do
    @artist.albums << create(:published_album, title: 'Album Title')

    get artist_path(@artist)

    assert_select 'p', 'Album Title'
  end

  test '#show should include draft albums' do
    @artist.albums << create(:draft_album, title: 'Album Title')

    get artist_path(@artist)

    assert_select 'p', 'draft'
  end

  test '#new' do
    get new_artist_path
    assert_response :success
  end

  test '#create' do
    assert_difference('Artist.count') do
      post artists_path, params: { artist: { name: 'Example' } }
    end

    assert_redirected_to edit_artist_path(Artist.last)
  end

  test '#create associates the new artist with the current user' do
    post artists_path, params: { artist: { name: 'Example' } }

    assert_equal @user, Artist.last.user

    assert_redirected_to edit_artist_path(Artist.last)
  end

  test '#edit' do
    get edit_artist_path(@artist)
    assert_response :success
  end

  test '#update' do
    patch artist_path(@artist), params: { artist: { name: 'New name' } }
    assert_redirected_to artist_path(@artist)
  end

  test '#destroy' do
    assert_difference('Artist.count', -1) do
      delete artist_path(@artist)
    end

    assert_redirected_to artists_path
  end
end

class ArtistsControllerTestSignedInArtist < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @artist = create(:artist)
    @user.artists << @artist

    log_in_as(@user)
  end

  test '#show should include published albums' do
    @artist.albums << create(:published_album, title: 'Album Title')

    get artist_path(@artist)

    assert_select 'p', 'Album Title'
  end

  test '#show should include draft albums' do
    @artist.albums << create(:draft_album, title: 'Album Title')

    get artist_path(@artist)

    assert_select 'p', 'draft'
  end
end

class ArtistsControllerTestSignedOut < ActionDispatch::IntegrationTest
  setup do
    @artist = create(:artist)
  end

  test '#index' do
    get artists_path
    assert_response :success
  end

  test '#index should only show listed artists' do
    get artists_path
    assert_select 'p', { count: 0, text: @artist.name }

    @artist.albums << create(:published_album)

    get artists_path
    assert_select 'p', { text: @artist.name }
  end

  test '#index includes auto-discovery link for atom feed' do
    get artists_path

    url = artists_url(format: :atom)
    assert_select "head link[rel='alternate'][type='application/atom+xml'][href='#{url}']"
  end

  test '#index with atom format should render atom feed' do
    @artist.update!(name: 'Older Artist')
    create(:published_album, artist: @artist, first_published_on: 3.days.ago)
    create(:draft_album, artist: @artist)

    another_artist = create(:artist, name: 'Newer Artist')
    create(:published_album, artist: another_artist, first_published_on: 1.day.ago)

    unlisted_artist = create(:artist, name: 'Unlisted Artist')
    create(:draft_album, artist: unlisted_artist)

    get artists_path(format: :atom)

    feed = RSS::Parser.parse(response.body)
    assert_equal 'Artists on jam.coop', feed.title.content
    assert_equal 'Newer Artist', feed.entries.first.title.content
    assert_equal 'Older Artist', feed.entries.last.title.content
    assert_not_includes feed.entries.map(&:title).map(&:content), 'Unlisted Artist'
  end

  test '#show should include published albums' do
    @artist.albums << create(:published_album, title: 'Album Title')

    get artist_path(@artist)

    assert_select 'p', 'Album Title'
  end

  test '#show should not include draft albums' do
    @artist.albums << create(:draft_album, title: 'Album Title')

    get artist_path(@artist)

    assert_select 'p', { text: 'draft', count: 0 }
  end

  test '#show includes auto-discovery link for atom feed' do
    get artist_path(@artist)

    url = artist_url(@artist, format: :atom)
    assert_select "head link[rel='alternate'][type='application/atom+xml'][href='#{url}']"
  end

  test '#show with atom format should render atom feed' do
    @artist.albums << create(:published_album, title: 'Older', released_on: 2.days.ago)
    @artist.albums << create(:published_album, title: 'Newer', released_on: 1.day.ago)
    @artist.albums << create(:draft_album, title: 'Draft', released_on: 0.days.ago)

    get artist_path(@artist, format: :atom)

    feed = RSS::Parser.parse(response.body)
    assert_equal "#{@artist.name} albums on jam.coop", feed.title.content
    assert_equal @artist.name, feed.author.name.content
    assert_equal 'Newer', feed.entries.first.title.content
    assert_equal 'Older', feed.entries.last.title.content
    assert_not_includes feed.entries.map(&:title).map(&:content), 'Draft'
  end

  test '#show with atom format for artist with no published albums should render atom feed' do
    @artist.albums << create(:draft_album)

    get artist_path(@artist, format: :atom)

    feed = RSS::Parser.parse(response.body)
    assert_equal "#{@artist.name} albums on jam.coop", feed.title.content
    assert_equal @artist.name, feed.author.name.content
    assert_equal 0, feed.entries.length
  end

  test '#new' do
    get new_artist_path
    assert_redirected_to log_in_path
  end

  test '#create' do
    post artists_path, params: { artist: { name: 'Example' } }
    assert_redirected_to log_in_path
  end

  test '#edit' do
    get edit_artist_path(@artist)
    assert_redirected_to log_in_path
  end

  test '#update' do
    patch artist_path(@artist), params: { artist: { name: 'New name' } }
    assert_redirected_to log_in_path
  end

  test '#destroy' do
    delete artist_path(@artist)

    assert_redirected_to log_in_path
  end
end
