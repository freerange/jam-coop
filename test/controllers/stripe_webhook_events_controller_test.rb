# frozen_string_literal: true

require 'test_helper'

class StripeWebhookEventsControllerTest < ActionDispatch::IntegrationTest
  test 'checkout.session.completed marks associated purchase as complete' do
    purchase = create(:purchase, stripe_session_id:)
    assert_not purchase.completed

    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => payload }

    assert purchase.reload.completed
    assert_response :success
  end

  test 'checkout.session.completed sets email address on purchase' do
    purchase = create(:purchase, stripe_session_id:)
    assert_nil purchase.customer_email

    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => payload }

    assert_equal customer_email, purchase.reload.customer_email
    assert_response :success
  end

  test 'invalid json in payload' do
    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => 'invalid-json' }

    assert_response :bad_request
  end

  test 'an event that is not checkout.success.completed' do
    event = stub(type: 'an.other.event')
    Stripe::Event.stubs(:construct_from).returns(event)

    post stripe_webhook_events_path, env: { 'RAW_POST_DATA' => payload }

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
end
