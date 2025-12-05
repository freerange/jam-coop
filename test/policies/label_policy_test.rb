# frozen_string_literal: true

require 'test_helper'

class LabelPolicyTest < ActiveSupport::TestCase
  test 'an admin' do
    user = build(:user, admin: true)
    label = build(:label)
    policy = LabelPolicy.new(user, label)

    assert policy.new?
    assert policy.create?
    assert policy.update?
    assert policy.edit?
  end

  test 'a verified user with labels enabled' do
    user = build(:user, verified: true, labels_enabled: true)
    label = build(:label)
    policy = LabelPolicy.new(user, label)

    assert policy.new?
    assert policy.create?
  end

  test 'a verified user without labels enabled' do
    user = build(:user, verified: true, labels_enabled: false)
    label = build(:label)
    policy = LabelPolicy.new(user, label)

    assert_not policy.new?
    assert_not policy.create?
  end

  test 'an unverified user' do
    user = build(:user, verified: false)
    label = build(:label)
    policy = LabelPolicy.new(user, label)

    assert_not policy.new?
    assert_not policy.create?
  end

  test 'a user who owns a label' do
    user = create(:user)
    label = create(:label, user:)
    policy = LabelPolicy.new(user, label)

    assert policy.update?
    assert policy.edit?
  end

  test 'a user who does not own a label' do
    user = create(:user)
    label = create(:label)
    policy = LabelPolicy.new(user, label)

    assert_not policy.update?
    assert_not policy.edit?
  end
end
