# frozen_string_literal: true

class PurchaseMailer < ApplicationMailer
  def completed
    @purchase = params[:purchase]

    return if @purchase.suppress_sending?

    mail to: @purchase.customer_email, subject: "Thank you for purchasing #{@purchase.album.title}"
  end

  def notify_artist
    @purchase = params[:purchase]

    return unless (@user = @purchase.album.artist.user)
    return if @user.suppress_sending?

    mail to: @user.email, subject: "You have sold a copy of #{@purchase.album.title}"
  end
end
