# frozen_string_literal: true

class ArtistPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.listed
      end
    end
  end

  def destroy?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin? || user.artists.include?(record)
  end

  def update?
    user.admin? || user.artists.include?(record)
  end

  def new?
    user.admin?
  end

  def view_unpublished_albums?
    user.admin? || user.artists.include?(record)
  end
end