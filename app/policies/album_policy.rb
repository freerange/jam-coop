# frozen_string_literal: true

class AlbumPolicy < ApplicationPolicy
  def create?
    user.admin? || user.artists.include?(record.artist)
  end

  def update?
    user.admin? || user.artists.include?(record.artist)
  end

  def edit?
    user.admin? || user.artists.include?(record.artist)
  end

  def unpublish?
    user.admin?
  end

  def new?
    user.admin? || user.artists.include?(record.artist)
  end

  def publish?
    user.admin?
  end
end