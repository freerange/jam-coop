# frozen_string_literal: true

module Admin
  class PayoutsController < AdminController
    def index
      @payouts = policy_scope(Payout).stripe.order(:created_at)
    end
  end
end
