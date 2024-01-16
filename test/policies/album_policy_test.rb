# frozen_string_literal: true

require 'test_helper'

class AlbumPolicyTest < ActiveSupport::TestCase
  test 'an admin' do
    user = build(:user, admin: true)
    album = build(:album)
    policy = AlbumPolicy.new(user, album)

    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.edit?
    assert policy.unpublish?
    assert policy.new?
    assert policy.publish?
    assert_not policy.request_publication?
  end

  test 'an admin scope' do
    user = build(:user, admin: true)
    unpublished_album = create(:unpublished_album)
    pending_album = create(:pending_album)
    published_album = create(:published_album)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_includes scope.resolve, unpublished_album
    assert_includes scope.resolve, pending_album
    assert_includes scope.resolve, published_album
  end

  test 'a user' do
    user = build(:user)
    album = build(:album)
    policy = AlbumPolicy.new(user, album)

    assert policy.show?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.unpublish?
    assert_not policy.new?
    assert_not policy.publish?
    assert_not policy.request_publication?
  end

  test 'a user with an album belonging to their artist' do
    album = create(:album)
    user = create(:user, artists: [album.artist])
    policy = AlbumPolicy.new(user, album)

    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.edit?
    assert_not policy.unpublish?
    assert policy.new?
    assert_not policy.publish?
    assert policy.request_publication?
  end

  test 'scope for a user with albums belonging to their artist' do
    user = build(:user)
    artist = create(:artist, user:)
    unpublished_album = create(:unpublished_album, artist:)
    pending_album = create(:pending_album, artist:)
    published_album = create(:published_album, artist:)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_includes scope.resolve, unpublished_album
    assert_includes scope.resolve, pending_album
    assert_includes scope.resolve, published_album
  end

  test 'non-signed-in user' do
    non_signed_in_user = NullUser.new
    unpublished_album = create(:unpublished_album)
    pending_album = create(:pending_album)
    published_album = create(:published_album)

    assert_not AlbumPolicy.new(non_signed_in_user, unpublished_album).show?
    assert_not AlbumPolicy.new(non_signed_in_user, pending_album).show?
    assert AlbumPolicy.new(non_signed_in_user, published_album).show?
  end

  test 'non-signed-in user scope' do
    user = NullUser.new
    unpublished_album = create(:unpublished_album)
    pending_album = create(:pending_album)
    published_album = create(:published_album)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_not_includes scope.resolve, unpublished_album
    assert_not_includes scope.resolve, pending_album
    assert_includes scope.resolve, published_album
  end

  test 'signed-in user' do
    user = build(:user)
    unpublished_album = create(:unpublished_album)
    pending_album = create(:pending_album)
    published_album = create(:published_album)

    assert_not AlbumPolicy.new(user, unpublished_album).show?
    assert_not AlbumPolicy.new(user, pending_album).show?
    assert AlbumPolicy.new(user, published_album).show?
  end

  test 'signed-in user scope' do
    user = build(:user)
    published_album = create(:published_album)
    pending_album = create(:pending_album)
    unpublished_album = create(:unpublished_album)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_not_includes scope.resolve, unpublished_album
    assert_not_includes scope.resolve, pending_album
    assert_includes scope.resolve, published_album
  end
end
