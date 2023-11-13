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
end
