# frozen_string_literal: true

class PurchaseCompleteJob < ApplicationJob
  queue_as :default

  def perform(stripe_session_id, customer_email)
    purchase = Purchase.find_by!(stripe_session_id:)
    purchase.update(completed: true, customer_email:)

    PurchaseMailer.with(purchase:).completed.deliver_later
  end
end
