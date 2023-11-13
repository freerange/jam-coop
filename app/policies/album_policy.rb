# frozen_string_literal: true

class AlbumPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def unpublish?
    user.admin?
  end

  def new?
    user.admin?
  end

  def publish?
    user.admin?
  end
end
