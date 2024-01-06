# frozen_string_literal: true

class PurchaseCompleteJob < ApplicationJob
  queue_as :default

  def perform(stripe_session_id, customer_email, amount_tax)
    purchase = Purchase.find_by!(stripe_session_id:)
    purchase.update(completed: true, customer_email:, amount_tax:)
    purchase.update(user: User.find_by(email: customer_email)) unless purchase.user

    PurchaseMailer.with(purchase:).completed.deliver_later
    PurchaseMailer.with(purchase:).notify_artist.deliver_later
  end
end
