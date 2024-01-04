# frozen_string_literal: true

require 'test_helper'

class PurchaseCompleteJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test 'it sets the completed state, email and amount_tax on the purchase' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax)

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

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax)

    assert_equal user, purchase.reload.user
  end

  test 'it emails the customer' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)

    assert_enqueued_email_with PurchaseMailer, :completed, params: { purchase: } do
      PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax)
    end
  end

  test 'it emails the artist' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    amount_tax = 140
    purchase = create(:purchase, stripe_session_id:)

    assert_enqueued_email_with PurchaseMailer, :notify_artist, params: { purchase: } do
      PurchaseCompleteJob.perform_now(stripe_session_id, customer_email, amount_tax)
    end
  end
end
