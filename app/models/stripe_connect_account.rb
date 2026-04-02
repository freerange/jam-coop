# frozen_string_literal: true

class StripeConnectAccount < ApplicationRecord
  belongs_to :user

  validates :country_code, presence: true, inclusion: { in: ['GB'], message: 'is not supported' }

  def sync_from!(stripe_account)
    update!(
      details_submitted: stripe_account.details_submitted?,
      charges_enabled: stripe_account.charges_enabled?,
      payouts_enabled: stripe_account.payouts_enabled?
    )
  end

  def accepts_payments?
    charges_enabled?
  end
end
