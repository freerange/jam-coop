# frozen_string_literal: true

require 'test_helper'

class StripeWebhookEventsControllerTest < ActionDispatch::IntegrationTest
  test 'checkout.session.completed marks associated purchase as complete' do
    checkout_session_id = 'cs_test_a11boUfs0kYSNA6S3K3z9XdMuXj5RwIdguh67hwQL47YmOjoa1WcUeWivv'
    customer_email = 'customer@example.com'
    amount_tax = 140

    params = checkout_session_completed_params(checkout_session_id, customer_email, amount_tax)
    headers = headers_for_event(params)

    PurchaseCompleteJob.expects(:perform_later).with(checkout_session_id, customer_email, amount_tax)

    post stripe_webhook_events_path, params:, headers:, as: :json

    assert_response :success
  end

  test 'account.updated updates Stripe Connect account status when details submitted' do
    stripe_identifier = 'acct_test_12345'
    stripe_connect_account = create(:stripe_connect_account, stripe_identifier:)

    params = account_updated_params(stripe_identifier, details_submitted: true)
    headers = headers_for_event(params)

    post stripe_webhook_events_path, params:, headers:, as: :json

    assert stripe_connect_account.reload.details_submitted?
    assert_response :success
  end

  test 'account.updated updates Stripe Connect account status when charges enabled' do
    stripe_identifier = 'acct_test_12345'
    stripe_connect_account = create(:stripe_connect_account, stripe_identifier:)

    params = account_updated_params(stripe_identifier, charges_enabled: true)
    headers = headers_for_event(params)

    post stripe_webhook_events_path, params:, headers:, as: :json

    assert stripe_connect_account.reload.charges_enabled?
    assert_response :success
  end

  test 'account.updated updates Stripe Connect account status when payouts enabled' do
    stripe_identifier = 'acct_test_12345'
    stripe_connect_account = create(:stripe_connect_account, stripe_identifier:)

    params = account_updated_params(stripe_identifier, payouts_enabled: true)
    headers = headers_for_event(params)

    post stripe_webhook_events_path, params:, headers:, as: :json

    assert stripe_connect_account.reload.payouts_enabled?
    assert_response :success
  end

  test 'invalid signature in payload' do
    post stripe_webhook_events_path, params: {}, headers: {}, as: :json

    assert_response :bad_request
  end

  test 'invalid json in payload' do
    Stripe::Webhook.stubs(:construct_event).raises(JSON::ParserError)

    post stripe_webhook_events_path

    assert_response :bad_request
  end

  test 'an unrecognized event' do
    params = { type: 'an.other.event' }
    headers = headers_for_event(params)

    post stripe_webhook_events_path, params:, headers:, as: :json

    assert_response :created
  end

  private

  def checkout_session_completed_params(checkout_session_id, customer_email, amount_tax)
    {
      type: 'checkout.session.completed',
      data: {
        object: {
          id: checkout_session_id,
          customer_details: {
            email: customer_email
          },
          total_details: {
            amount_tax:
          }
        }
      }
    }
  end

  def account_updated_params(stripe_account_id, **statuses)
    statuses.with_defaults!(
      details_submitted: false,
      charges_enabled: false,
      payouts_enabled: false
    )
    {
      type: 'account.updated',
      data: {
        object: {
          id: stripe_account_id,
          **statuses
        }
      }
    }
  end

  def headers_for_event(params)
    payload = params.to_json
    timestamp = Time.current
    signature = Stripe::Webhook::Signature.compute_signature(timestamp, payload, webhook_secret)
    signature_header = Stripe::Webhook::Signature.generate_header(timestamp, signature)
    { 'Stripe-Signature' => signature_header }
  end

  def webhook_secret
    StripeWebhookEventsController::ENDPOINT_SECRET
  end
end
