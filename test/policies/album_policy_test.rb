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
    assert policy.new?
  end

  test 'an admin scope' do
    user = build(:user, admin: true)
    draft_album = create(:draft_album)
    published_album = create(:published_album)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_includes scope.resolve, draft_album
    assert_includes scope.resolve, published_album
  end

  test 'a user' do
    user = build(:user)
    album = build(:published_album)
    policy = AlbumPolicy.new(user, album)

    assert policy.show?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.new?
  end

  test 'a user with an album belonging to their artist' do
    album = build(:album)
    user = build(:user, artists: [album.artist])
    policy = AlbumPolicy.new(user, album)

    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.edit?
    assert policy.new?
  end

  test 'scope for a user with albums belonging to their artist' do
    user = build(:user)
    artist = create(:artist, user:)
    draft_album = create(:draft_album, artist:)
    published_album = create(:published_album, artist:)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_includes scope.resolve, draft_album
    assert_includes scope.resolve, published_album
  end

  test 'non-signed-in user' do
    non_signed_in_user = NullUser.new
    draft_album = build(:draft_album)
    published_album = build(:published_album)

    assert_not AlbumPolicy.new(non_signed_in_user, draft_album).show?
    assert AlbumPolicy.new(non_signed_in_user, published_album).show?
  end

  test 'non-signed-in user scope' do
    user = NullUser.new
    draft_album = create(:draft_album)
    published_album = create(:published_album)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_not_includes scope.resolve, draft_album
    assert_includes scope.resolve, published_album
  end

  test 'signed-in user' do
    user = build(:user)
    draft_album = build(:draft_album)
    published_album = build(:published_album)

    assert_not AlbumPolicy.new(user, draft_album).show?
    assert AlbumPolicy.new(user, published_album).show?
  end

  test 'signed-in user scope' do
    user = build(:user)
    published_album = create(:published_album)
    draft_album = create(:draft_album)

    scope = AlbumPolicy::Scope.new(user, Album.all)

    assert_not_includes scope.resolve, draft_album
    assert_includes scope.resolve, published_album
  end
end
