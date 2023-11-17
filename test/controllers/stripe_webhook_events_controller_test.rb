# frozen_string_literal: true

require 'test_helper'

class StripeWebhookEventsControllerTest < ActionDispatch::IntegrationTest
  test 'checkout.session.completed marks associated purchase as complete' do
    purchase = create(:purchase, stripe_session_id:)
    assert_not purchase.completed

    Stripe::Webhook.expects(:construct_event).with(payload, 'signature', nil).returns(stripe_event)
    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => payload, 'HTTP_STRIPE_SIGNATURE' => 'signature' }

    assert purchase.reload.completed
    assert_response :success
  end

  test 'checkout.session.completed sets email address on purchase' do
    purchase = create(:purchase, stripe_session_id:)
    assert_nil purchase.customer_email

    Stripe::Webhook.expects(:construct_event).with(payload, 'signature', nil).returns(stripe_event)
    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => payload, 'HTTP_STRIPE_SIGNATURE' => 'signature' }

    assert_equal customer_email, purchase.reload.customer_email
    assert_response :success
  end

  test 'invalid json in payload' do
    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => 'invalid-json' }

    assert_response :bad_request
  end

  test 'an event that is not checkout.success.completed' do
    event = stub(type: 'an.other.event')
    Stripe::Webhook.stubs(:construct_event).with(payload, 'signature', nil).returns(event)

    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => payload, 'HTTP_STRIPE_SIGNATURE' => 'signature' }

    assert_response :created
  end

  private

  def payload
    Rails.root.join('test/fixtures/files/stripe/checkout.session.completed.json').read
  end

  def stripe_session_id
    JSON.parse(payload)['data']['object']['id']
  end

  def customer_email
    JSON.parse(payload)['data']['object']['customer_details']['email']
  end

  def stripe_event
    Stripe::Event.construct_from(JSON.parse(payload), symbolize_names: true)
  end
end
