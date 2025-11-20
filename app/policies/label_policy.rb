# frozen_string_literal: true

class LabelPolicy < ApplicationPolicy
  def new?
    user.admin? || user.verified?
  end

  def create?
    user.admin? || user.verified?
  end

  def update?
    user.admin? || user.labels.include?(record)
  end

  def edit?
    user.admin? || user.labels.include?(record)
  end
end
