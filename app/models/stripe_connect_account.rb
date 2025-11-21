# frozen_string_literal: true

class StripeConnectAccount < ApplicationRecord
  belongs_to :user

  validates :stripe_identifier, presence: true

  def sync_from!(stripe_account)
    update!(
      details_submitted: stripe_account.details_submitted?,
      charges_enabled: stripe_account.charges_enabled?,
      payouts_enabled: stripe_account.payouts_enabled?
    )
  end

  def status
    if charges_enabled?
      'charges_enabled'
    elsif details_submitted?
      'details_submitted'
    else
      'not_started'
    end
  end

  def accepts_payments?
    charges_enabled?
  end
end
