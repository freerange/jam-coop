# frozen_string_literal: true

class PurchaseCompleteJob < ApplicationJob
  queue_as :default

  def perform(stripe_session_id, customer_email, amount_tax, destination_account_identifier)
    purchase = Purchase.find_by!(stripe_session_id:)
    purchase.update(completed: true, customer_email:, amount_tax:)
    purchase.update(user: User.find_by(email: customer_email)) unless purchase.user

    if destination_account_identifier.present?
      stripe_connect_account = StripeConnectAccount.find_by(stripe_identifier: destination_account_identifier)
      if stripe_connect_account.present?
        purchase.update(stripe_connect_account:)
      else
        Rollbar.error("Destination account identifier not found: #{destination_account_identifier}")
      end
    end

    PurchaseMailer.with(purchase:).completed.deliver_later
    PurchaseMailer.with(purchase:).notify_artist.deliver_later
  end
end
