# frozen_string_literal: true

require 'test_helper'

class PurchaseCompleteJobTest < ActiveJob::TestCase
  test 'it sets the completed state and email on the purchase' do
    stripe_session_id = 'session-id'
    customer_email = 'email@example.com'
    purchase = create(:purchase, stripe_session_id:)

    PurchaseCompleteJob.perform_now(stripe_session_id, customer_email)

    assert purchase.reload.completed
    assert_equal customer_email, purchase.reload.customer_email
  end
end
