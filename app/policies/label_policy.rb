# frozen_string_literal: true

class LabelPolicy < ApplicationPolicy
  def new?
    user.admin? || (user.verified? && user.labels_enabled?)
  end

  def create?
    user.admin? || (user.verified? && user.labels_enabled?)
  end

  def update?
    user.admin? || user.labels.include?(record)
  end

  def edit?
    user.admin? || user.labels.include?(record)
  end

  def destroy?
    user.admin? || user.labels.include?(record)
  end
end
