# frozen_string_literal: true

class AlbumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.published.or(scope.where(artist_id: user.artists.select(:id)))
      end
    end
  end

  def index?
    true
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

  def destroy?
    user.admin? || user.artists.include?(record.artist)
  end
end
