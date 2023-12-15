# frozen_string_literal: true

class PayoutDetailPolicy < ApplicationPolicy
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
end
