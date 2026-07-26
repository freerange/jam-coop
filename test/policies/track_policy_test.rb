# frozen_string_literal: true

require 'test_helper'

class TrackPolicyTest < ActiveSupport::TestCase
  setup do
    user = build(:user)
    album = build(:album)
    track = build(:track, album:)
    @policy = TrackPolicy.new(user, track)
  end

  test 'delegates new? to policy for album' do
    @policy.album_policy.expects(:new?)

    @policy.new?
  end

  test 'delegates create to policy for album' do
    @policy.album_policy.expects(:create?)

    @policy.create?
  end

  test 'delegates edit? to policy for album' do
    @policy.album_policy.expects(:edit?)

    @policy.edit?
  end

  test 'delegates update? to policy for album' do
    @policy.album_policy.expects(:update?)

    @policy.update?
  end

  test 'delegates destroy? to policy for track album' do
    @policy.album_policy.expects(:destroy?)

    @policy.destroy?
  end

  test 'aliases multiple? to new?' do
    @policy.album_policy.expects(:new?)

    @policy.multiple?
  end

  test 'aliases create_multiple? to create?' do
    @policy.album_policy.expects(:create?)

    @policy.create_multiple?
  end

  test 'aliases move_lower? to update?' do
    @policy.album_policy.expects(:update?)

    @policy.move_lower?
  end

  test 'aliases move_higher? to update?' do
    @policy.album_policy.expects(:update?)

    @policy.move_higher?
  end
end
