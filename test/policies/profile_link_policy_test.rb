# frozen_string_literal: true

require 'test_helper'

class ProfileLinkPolicyTest < ActiveSupport::TestCase
  test 'an admin can add new links to any profile' do
    user = build(:user, admin: true)
    artist = build(:artist)
    link = artist.profile_links.build
    policy = ProfileLinkPolicy.new(user, link)

    assert policy.new?
  end

  test 'an unverified artist cannot add new links to their own profile' do
    user = create(:user, verified: false)
    artist = create(:artist, user:)
    link = artist.profile_links.build

    policy = ProfileLinkPolicy.new(user, link)
    assert_not policy.new?
  end

  test 'a verified artist can add new links to their own profile' do
    user = create(:user, verified: true)
    artist = create(:artist, user:)
    link = artist.profile_links.build

    policy = ProfileLinkPolicy.new(user, link)
    assert policy.new?
  end

  test 'a verified artist cannot add new links to another profile' do
    user = create(:user, verified: true)
    other_user = create(:user, verified: true)
    other_artist = create(:artist, user: other_user)
    other_link = other_artist.profile_links.build

    policy = ProfileLinkPolicy.new(user, other_link)
    assert_not policy.new?
  end
end
