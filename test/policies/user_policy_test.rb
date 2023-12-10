# frozen_string_literal: true

require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  test 'an admin' do
    user = build(:user, admin: true)
    record = build(:user)
    policy = UserPolicy.new(user, record)

    assert policy.show?
    assert policy.edit?
    assert policy.update?
    assert policy.create?
    assert policy.new?
  end

  test 'a user' do
    user = build(:user)
    record = build(:user)
    policy = UserPolicy.new(user, record)

    assert policy.show?
    assert policy.edit?
    assert policy.update?
    assert_not policy.create?
    assert_not policy.new?
  end
end
