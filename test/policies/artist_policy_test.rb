# frozen_string_literal: true

require 'test_helper'

class ArtistPolicyTest < ActiveSupport::TestCase
  test 'an admin' do
    user = build(:user, admin: true)
    artist = build(:artist)
    policy = ArtistPolicy.new(user, artist)

    assert policy.destroy?
    assert policy.create?
    assert policy.update?
    assert policy.edit?
    assert policy.new?
  end

  test 'an admin scope' do
    user = build(:user, admin: true)
    listed_artist = create(:artist)
    unlisted_artist = create(:artist, listed: false)

    scope = ArtistPolicy::Scope.new(user, Artist)

    assert_includes scope.resolve, listed_artist
    assert_includes scope.resolve, unlisted_artist
  end

  test 'a user' do
    user = build(:user)
    artist = build(:artist)
    policy = ArtistPolicy.new(user, artist)

    assert_not policy.destroy?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.edit?
    assert_not policy.new?
  end

  test 'a user scope' do
    user = build(:user)
    listed_artist = create(:artist)
    create(:artist, listed: false)

    scope = ArtistPolicy::Scope.new(user, Artist)

    assert_equal [listed_artist], scope.resolve
  end

  test 'a user with an artist' do
    artist = create(:artist)
    user = create(:user, artists: [artist])

    policy = ArtistPolicy.new(user, artist)

    assert_not policy.destroy?
    assert_not policy.create?
    assert policy.update?
    assert policy.edit?
    assert_not policy.new?
  end
end
