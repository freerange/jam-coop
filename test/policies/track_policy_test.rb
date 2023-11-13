# frozen_string_literal: true

require 'test_helper'

class TrackPolicyTest < ActiveSupport::TestCase
  test 'an admin' do
    user = build(:user, admin: true)
    track = build(:track)
    policy = TrackPolicy.new(user, track)

    assert policy.move_higher?
    assert policy.move_lower?
  end

  test 'a user' do
    user = build(:user)
    track = build(:track)
    policy = TrackPolicy.new(user, track)

    assert_not policy.move_higher?
    assert_not policy.move_lower?
  end
end
