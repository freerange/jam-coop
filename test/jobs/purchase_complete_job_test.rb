# frozen_string_literal: true

require 'test_helper'

class PurchaseCompleteJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test 'it sets the completed state, email and amount_tax on the purchase' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    destination = nil

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax, destination)

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
    destination = nil

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax, destination)

    assert_equal user, purchase.reload.user
  end

  test 'does not overwrite the user if already set' do
    stripe_session_id = 'session-id'
    user = create(:user)
    customer_email = 'non-existant-email'
    amount_tax = 140
    purchase = create(:purchase, user:, stripe_session_id:)
    destination = nil

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax, destination)

    assert_equal user, purchase.reload.user
  end

  test 'associates the purchase with a Stripe Connect account if destination identifier provided' do
    stripe_session_id = 'session-id'
    user = create(:user)
    customer_email = user.email
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    destination = 'acct_test_abc123'

    stripe_connect_account = create(:stripe_connect_account, stripe_identifier: destination)

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax, destination)

    assert_equal stripe_connect_account, purchase.reload.stripe_connect_account
  end

  test 'reports an error to Rollbar if destination identifier provided but Stripe Connect account not found' do
    stripe_session_id = 'session-id'
    user = create(:user)
    customer_email = user.email
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    destination = 'acct_test_abc123'

    Rollbar.expects(:error).with("Destination account identifier not found: #{destination}")

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax, destination)

    assert_nil purchase.reload.stripe_connect_account
  end

  test 'it emails the customer' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    destination = nil

    assert_enqueued_email_with PurchaseMailer, :completed, params: { purchase: } do
      PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax, destination)
    end
  end

  test 'it emails the artist' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)
    destination = nil

    assert_enqueued_email_with PurchaseMailer, :notify_artist, params: { purchase: } do
      PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax, destination)
    end
  end
end
