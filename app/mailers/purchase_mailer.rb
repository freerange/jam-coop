# frozen_string_literal: true

class PurchaseMailer < ApplicationMailer
  def completed
    @purchase = params[:purchase]

    mail to: @purchase.customer_email, subject: "Thank you for purchasing #{@purchase.album.title}"
  end
end
