# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  def access?
    user.admin?
  end
end
