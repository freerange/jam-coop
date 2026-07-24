# frozen_string_literal: true

class PayoutsController < ApplicationController
  def index
    @payouts = Current.user.stripe_payouts.order(:created_at)
    authorize @payouts
  end
end
