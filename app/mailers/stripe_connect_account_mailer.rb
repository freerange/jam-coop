# frozen_string_literal: true

class StripeConnectAccountMailer < ApplicationMailer
  helper StripeConnectAccountHelper

  def charges_enabled
    @account = params[:account]

    seller = @account.user
    return if seller.suppress_sending?

    mail to: seller.email, subject: 'Your Stripe account now accepts payments'
  end

  def payouts_enabled
    @account = params[:account]

    seller = @account.user
    return if seller.suppress_sending?

    mail to: seller.email, subject: 'Your Stripe account now allows payouts'
  end
end
