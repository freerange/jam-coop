# frozen_string_literal: true

require 'test_helper'

class FollowingPolicyTest < ActiveSupport::TestCase
  test 'anyone' do
    user = build(:user)
    policy = FollowingPolicy.new(user, Following)

    assert policy.create?
    assert policy.destroy?
  end
end
