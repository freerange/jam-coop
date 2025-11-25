# frozen_string_literal: true

class StripeAccountPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end

  def link?
    true
  end

  def success?
    true
  end
end
