# frozen_string_literal: true

require 'test_helper'

class TrackPolicyTest < ActiveSupport::TestCase
  test 'an admin acting on a track from an draft album' do
    user = build(:user, admin: true)
    track = build(:track, album: build(:draft_album))
    policy = TrackPolicy.new(user, track)

    assert policy.move_higher?
    assert policy.move_lower?
    assert policy.reorder?
  end

  test 'an admin acting on a track from an published album' do
    user = build(:user, admin: true)
    track = build(:track, album: build(:published_album))
    policy = TrackPolicy.new(user, track)

    assert_not policy.move_higher?
    assert_not policy.move_lower?
    assert_not policy.reorder?
  end

  test 'a user' do
    user = build(:user)
    track = build(:track)
    policy = TrackPolicy.new(user, track)

    assert_not policy.move_higher?
    assert_not policy.move_lower?
    assert_not policy.reorder?
  end
end
