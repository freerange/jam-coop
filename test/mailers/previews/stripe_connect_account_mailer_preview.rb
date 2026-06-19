# frozen_string_literal: true

class StripeConnectAccountMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def charges_enabled
    account = build(:stripe_connect_account)

    StripeConnectAccountMailer.with(account:).charges_enabled
  end

  def payouts_enabled
    account = build(:stripe_connect_account)

    StripeConnectAccountMailer.with(account:).payouts_enabled
  end
end
