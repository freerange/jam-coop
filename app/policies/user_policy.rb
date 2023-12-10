# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def edit?
    true
  end

  def update?
    true
  end

  def create?
    user.admin?
  end

  def new?
    user.admin?
  end

  def show?
    true
  end
end
