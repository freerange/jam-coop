# frozen_string_literal: true

class TrackPolicy < ApplicationPolicy
  def move_higher?
    record.draft? && user.admin?
  end

  def move_lower?
    record.draft? && user.admin?
  end

  def reorder?
    record.draft? && move_lower? && move_higher?
  end
end
