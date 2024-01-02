# frozen_string_literal: true

class TrackPolicy < ApplicationPolicy
  def move_higher?
    record.unpublished? && user.admin?
  end

  def move_lower?
    record.unpublished? && user.admin?
  end

  def reorder?
    record.unpublished? && move_lower? && move_higher?
  end
end
