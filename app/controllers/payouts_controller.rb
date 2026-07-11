# frozen_string_literal: true

class PayoutsController < ApplicationController
  def index
    @payouts = authorize Current.user.stripe_payouts.order(:created_at)
  end
end
