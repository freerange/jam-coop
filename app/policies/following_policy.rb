# frozen_string_literal: true

class FollowingPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    true
  end
end
