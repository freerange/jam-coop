# frozen_string_literal: true

require 'test_helper'

class ReleasePolicyTest < ActiveSupport::TestCase
  setup do
    user = build(:user)
    label = build(:label)
    release = build(:release, label:)
    @policy = ReleasePolicy.new(user, release)
  end

  test 'delegates new? to policy for label' do
    @policy.label_policy.expects(:new?)

    @policy.new?
  end

  test 'delegates create to policy for label' do
    @policy.label_policy.expects(:create?)

    @policy.create?
  end

  test 'delegates edit? to policy for label' do
    @policy.label_policy.expects(:edit?)

    @policy.edit?
  end

  test 'delegates update? to policy for label' do
    @policy.label_policy.expects(:update?)

    @policy.update?
  end

  test 'delegates destroy? to policy for label' do
    @policy.label_policy.expects(:destroy?)

    @policy.destroy?
  end
end
