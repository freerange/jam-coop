# frozen_string_literal: true

class LabelPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.with_albums
      end
    end
  end

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
