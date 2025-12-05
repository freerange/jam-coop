# frozen_string_literal: true

class PayoutJob < ApplicationJob
  queue_as :default

  def perform(charge_id)
    charge = Stripe::Charge.retrieve({
      id: charge_id,
      expand: [
        'payment_intent',
        'balance_transaction'
      ]
    })

    stripe_sessions = Stripe::Checkout::Session.list({ payment_intent: charge.payment_intent })
    stripe_session = stripe_sessions.data.last
    return unless stripe_session.present?

    purchase = Purchase.where(completed: true).find_by(stripe_session_id: stripe_session.id)
    return unless purchase.present?

    stripe_fee_in_pence = charge.balance_transaction.fee
    user = purchase.album.artist.user
    stripe_account = Stripe::Account.retrieve(user.stripe_account.stripe_identifier)

    transfer = Stripe::Transfer.create({
      amount: purchase.price_in_pence - purchase.platform_fee_in_pence - stripe_fee_in_pence,
      currency: 'gbp',
      source_transaction: charge,
      destination: stripe_account
    })

    # TODO: Extract customer details for other business types
    unless stripe_account.business_type == 'individual'
      "Unhandled Stripe account business type: #{stripe_account.business_type}"
    end

    customer = Stripe::Customer.create({
      name: [stripe_account.individual.first_name, stripe_account.individual.last_name].join(' '),
      email: stripe_account.email, # or stripe_account.individual.first_name
      description: "Connected account: #{stripe_account.id}",
      address: {
        country: stripe_account.country # or stripe_account.individual.address.country
      },
      metadata: {
        connected_account_id: stripe_account.id
      },
    })

    invoice = Stripe::Invoice.create({
      customer:,
      collection_method: 'send_invoice',
      days_until_due: 0,
      automatic_tax: { enabled: true },
      description: 'Platform fees',
      footer: 'These fees were automatically deducted from your sale proceeds. No payment is required. For information only.',
        metadata: {
        checkout_session_id: stripe_session.id,
      }
    })

    # txcd_10401100 - Digital Audio Works - downloaded - non subscription - with permanent rights
    # txcd_90020001 - Optional gratuity

    Stripe::InvoiceItem.create({
      customer:,
      invoice:,
      amount: purchase.platform_fee_in_pence,
      currency: 'gbp',
      description: 'Platform fee (automatically deducted from sale)',
      tax_behavior: 'inclusive',
      tax_code: 'txcd_10000000', # General - Electronically Supplied Services
    })

    Stripe::InvoiceItem.create({
      customer:,
      invoice:,
      amount: stripe_fee_in_pence,
      currency: 'gbp',
      description: 'Stripe processing fee (automatically deducted from sale)',
      tax_behavior: 'inclusive',
      tax_code: 'txcd_00000000', # Non-taxable
    })

    invoice.finalize_invoice

    Stripe::Invoice.pay(invoice.id, { paid_out_of_band: true })

    PurchaseMailer.with(purchase:).notify_artist.deliver_later
  end
end
