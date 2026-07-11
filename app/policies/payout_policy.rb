# frozen_string_literal: true

class PayoutPolicy < ApplicationPolicy
  def index?
    user&.stripe_connect_account&.accepts_payments?
  end
end
