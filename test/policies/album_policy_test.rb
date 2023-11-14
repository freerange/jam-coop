# frozen_string_literal: true

require 'test_helper'

class AlbumPolicyTest < ActiveSupport::TestCase
  test 'an admin' do
    user = build(:user, admin: true)
    album = build(:album)
    policy = AlbumPolicy.new(user, album)

    assert policy.create?
    assert policy.update?
    assert policy.edit?
    assert policy.unpublish?
    assert policy.new?
    assert policy.publish?
  end

  test 'an admin scope' do
    user = build(:user, admin: true)
    published_album = create(:album, published: true)
    unpublished_album = create(:album, published: false)

    scope = AlbumPolicy::Scope.new(user, Album)

    assert_includes scope.resolve, published_album
    assert_includes scope.resolve, unpublished_album
  end

  test 'a user' do
    user = build(:user)
    album = build(:album)
    policy = AlbumPolicy.new(user, album)

    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.unpublish?
    assert_not policy.new?
    assert_not policy.publish?
  end

  test 'a user scope' do
    user = build(:user)
    published_album = create(:album, published: true)
    create(:album, published: false)

    scope = AlbumPolicy::Scope.new(user, Album)

    assert_equal [published_album], scope.resolve
  end
end
