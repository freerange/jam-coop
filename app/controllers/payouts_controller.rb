# frozen_string_literal: true

class PayoutsController < ApplicationController
  before_action :skip_authorization

  def index
    @payouts = policy_scope(Payout).stripe.where(user: Current.user).order(:created_at)
  end
end
