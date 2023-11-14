# frozen_string_literal: true

class TrackPolicy < ApplicationPolicy
  def move_higher?
    user.admin?
  end

  def move_lower?
    user.admin?
  end

  def reorder?
    move_lower? && move_higher?
  end
end
