# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/stripe_connect_account_mailer
class StripeConnectAccountMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  # Preview this email at http://localhost:3000/rails/mailers/stripe_connect_account_mailer/charges_enabled
  def charges_enabled
    account = build(:stripe_connect_account)

    StripeConnectAccountMailer.with(account:).charges_enabled
  end

  # Preview this email at http://localhost:3000/rails/mailers/stripe_connect_account_mailer/payouts_enabled
  def payouts_enabled
    account = build(:stripe_connect_account)

    StripeConnectAccountMailer.with(account:).payouts_enabled
  end
end
