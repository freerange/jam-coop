# frozen_string_literal: true

class StripeConnectAccount < ApplicationRecord
  belongs_to :user

  validates :country_code, presence: true, inclusion: { in: ['GB'], message: 'is not supported', allow_blank: true }

  def sync_from!(stripe_account)
    update!(
      details_submitted: stripe_account.details_submitted?,
      charges_enabled: stripe_account.charges_enabled?,
      payouts_enabled: stripe_account.payouts_enabled?
    )
    mailer.charges_enabled.deliver_later if charges_enabled? && charges_enabled_previously_changed?
    mailer.payouts_enabled.deliver_later if payouts_enabled? && payouts_enabled_previously_changed?
  end

  def accepts_payments?
    charges_enabled?
  end

  def mailer
    StripeConnectAccountMailer.with(account: self)
  end
end
