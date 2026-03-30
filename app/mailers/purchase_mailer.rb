# frozen_string_literal: true

class PurchaseMailer < ApplicationMailer
  def completed
    @purchase = params[:purchase]

    return if @purchase.suppress_sending?

    mail to: @purchase.customer_email, subject: "Thank you for purchasing #{@purchase.album.title}"
  end

  def notify_artist
    @purchase = params[:purchase]

    return unless (@seller = @purchase.seller)
    return if @seller.suppress_sending?

    @stripe_account = @seller.stripe_connect_account

    mail to: @seller.email, subject: "You have sold a copy of #{@purchase.album.title}"
  end
end
