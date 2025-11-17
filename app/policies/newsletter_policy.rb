# frozen_string_literal: true

class NewsletterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end
end
