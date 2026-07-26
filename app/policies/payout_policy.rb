# frozen_string_literal: true

class PayoutPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user:)
      end
    end
  end

  def index?
    user&.stripe_connect_account&.accepts_payments?
  end
end
