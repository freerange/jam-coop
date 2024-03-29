# frozen_string_literal: true

require 'test_helper'

class SessionPolicyTest < ActiveSupport::TestCase
  test 'an admin' do
    user = build(:user, admin: true)
    record = nil
    policy = SessionPolicy.new(user, record)

    assert policy.index?
  end

  test 'a user' do
    user = build(:user)
    record = nil
    policy = SessionPolicy.new(user, record)

    assert policy.index?
  end
end
