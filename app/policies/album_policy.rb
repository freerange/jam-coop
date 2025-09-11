# frozen_string_literal: true

class AlbumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin? || scope.map(&:artist).uniq.all? { |a| user.artists.include?(a) }
        scope.all
      else
        scope.published
      end
    end
  end

  def show?
    return record.published? unless user.signed_in?

    record.published? || user.admin? || user.artists.include?(record.artist)
  end

  def create?
    user.admin? || user.artists.include?(record.artist)
  end

  def update?
    user.admin? || user.artists.include?(record.artist)
  end

  def edit?
    user.admin? || user.artists.include?(record.artist)
  end

  def new?
    user.admin? || user.artists.include?(record.artist)
  end

  def publish?
    user.admin?
  end
end
