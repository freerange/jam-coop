# frozen_string_literal: true

class PurchasePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.for_seller(user)
      end
    end
  end

  def index?
    user.signed_in?
  end
end
