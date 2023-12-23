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

  test 'a user' do
    user = build(:user)
    album = build(:album)
    policy = AlbumPolicy.new(user, album)

    assert_not policy.show?
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

  test 'non-signed-in user' do
    non_signed_in_user = NullUser.new
    unpublished_album = create(:album, publication_status: :unpublished)
    pending_album = create(:album, publication_status: :pending)
    published_album = create(:album, publication_status: :published)

    assert_not AlbumPolicy.new(non_signed_in_user, unpublished_album).show?
    assert_not AlbumPolicy.new(non_signed_in_user, pending_album).show?
    assert AlbumPolicy.new(non_signed_in_user, published_album).show?
  end
end
