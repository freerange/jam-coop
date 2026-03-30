# frozen_string_literal: true

require 'test_helper'

class PurchaseCompleteJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test 'it sets the completed state, email and amount_tax on the purchase' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    session = stub_retrieve_stripe_checkout_session(stripe_session_id, customer_email, amount_tax)
    stub_retrieve_stripe_payment_intent(session.payment_intent)

    PurchaseCompleteJob.perform_now(stripe_session_id)

    assert purchase.reload.completed
    assert_equal customer_email, purchase.reload.customer_email
    assert_equal 140, purchase.reload.amount_tax
  end

  test 'associates the purchase with a user if one exists with this customer_email' do
    stripe_session_id = 'session-id'
    user = create(:user)
    customer_email = user.email
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    session = stub_retrieve_stripe_checkout_session(stripe_session_id, customer_email, amount_tax)
    stub_retrieve_stripe_payment_intent(session.payment_intent)

    PurchaseCompleteJob.perform_now(stripe_session_id)

    assert_equal user, purchase.reload.user
  end

  test 'does not overwrite the user if already set' do
    stripe_session_id = 'session-id'
    user = create(:user)
    customer_email = 'non-existant-email'
    amount_tax = 140
    purchase = create(:purchase, user:, stripe_session_id:)
    session = stub_retrieve_stripe_checkout_session(stripe_session_id, customer_email, amount_tax)
    stub_retrieve_stripe_payment_intent(session.payment_intent)

    PurchaseCompleteJob.perform_now(stripe_session_id)

    assert_equal user, purchase.reload.user
  end

  test 'it emails the customer' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    session = stub_retrieve_stripe_checkout_session(stripe_session_id, customer_email, amount_tax)
    stub_retrieve_stripe_payment_intent(session.payment_intent)

    assert_enqueued_email_with PurchaseMailer, :completed, params: { purchase: } do
      PurchaseCompleteJob.perform_now(stripe_session_id)
    end
  end

  test 'it creates a payout associated with the seller and the purchase' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    session = stub_retrieve_stripe_checkout_session(stripe_session_id, customer_email, amount_tax)
    payment_intent_id = session.payment_intent
    destination = 'acct_1T7Y4RLr1GW0yJYq'
    stub_retrieve_stripe_payment_intent(payment_intent_id, 550, 150, { destination: })

    PurchaseCompleteJob.perform_now(stripe_session_id)

    payouts = purchase.seller.payouts
    assert_equal 1, payouts.length
    payout = payouts.last
    assert payout.stripe?
    assert_equal payout.transaction_reference, payment_intent_id
    assert_equal payout.destination_reference, destination
    assert_equal payout.amount_in_pence, 550
    assert_equal payout.platform_fee_in_pence, 150

    assert_equal payout, purchase.reload.payout
  end

  test 'it emails the artist' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    session = stub_retrieve_stripe_checkout_session(stripe_session_id, customer_email, amount_tax)
    stub_retrieve_stripe_payment_intent(session.payment_intent)

    assert_enqueued_email_with PurchaseMailer, :notify_artist, params: { purchase: } do
      PurchaseCompleteJob.perform_now(stripe_session_id)
    end
  end
end
