# frozen_string_literal: true

require 'test_helper'

class ActivityFeedPolicyTest < ActiveSupport::TestCase
  test 'anyone' do
    user = build(:user)
    policy = ActivityFeedPolicy.new(user, Following)

    assert policy.show?
  end
end
