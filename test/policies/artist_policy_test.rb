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
end
