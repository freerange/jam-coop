# frozen_string_literal: true

require 'test_helper'

class EmailSubscriptionChangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.configuration.stubs(:postmark).returns({ webhooks_token: 'token' })
  end

  test 'hard bounce from outbound suppresses sending for user' do
    params = params(stream: 'outbound', reason: 'HardBounce')
    user = create_user(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    user.reload
    assert user.suppress_sending?
    assert_equal Time.zone.iso8601(params['ChangedAt']), user.sending_suppressed_at
  end

  test 'hard bounce from outbound suppresses sending for interest' do
    params = params(stream: 'outbound', reason: 'HardBounce')
    interest = create_interest(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    interest.reload
    assert interest.suppress_sending?
    assert_equal Time.zone.iso8601(params['ChangedAt']), interest.sending_suppressed_at
  end

  test 'hard bounce from outbound suppresses sending for purchase' do
    params = params(stream: 'outbound', reason: 'HardBounce')
    purchase = create_purchase(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    purchase.reload
    assert purchase.suppress_sending?
    assert_equal Time.zone.iso8601(params['ChangedAt']), purchase.sending_suppressed_at
  end

  test 'does not suppress sending for user if bearer token is not valid' do
    post(email_subscription_changes_path, headers: headers(token: 'invalid'), params:)

    assert_response :unauthorized
  end

  test 'does not suppress sending if user or interest with email does not exist' do
    post(email_subscription_changes_path, headers:, params:)

    assert_response :not_found
    assert_equal({ 'error' => 'not_found' }, response.parsed_body)
  end

  test 'does not suppress sending if validation error occurs' do
    user = create_user(email: params['Recipient'])
    user.errors.add(:email, 'has an error')
    User.any_instance.stubs(:update!).raises(ActiveRecord::RecordInvalid.new(user))

    post(email_subscription_changes_path, headers:, params:)

    assert_response :unprocessable_content
    assert_equal({ 'error' => 'invalid', 'messages' => ['Email has an error'] }, response.parsed_body)
    assert_not user.reload.suppress_sending?
  end

  test 'raises an exception if the message stream is not known' do
    params = params(stream: 'unknown-stream')
    create_user(email: params['Recipient'])
    post(email_subscription_changes_path, headers:, params:)

    assert_response :unprocessable_content
  end

  test 'ManualSuppression from broadcast sets User#opt_in_to_newsletter false' do
    params = params(stream: 'broadcast', reason: 'ManualSuppression')
    user = create_user(email: params['Recipient'], opt_in_to_newsletter: true)

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    user.reload

    assert_not user.suppress_sending?
    assert_not user.opt_in_to_newsletter?
  end

  test 'ManualSuppression from broadcast suppresses sending for interest' do
    params = params(stream: 'broadcast', reason: 'ManualSuppression')
    interest = create_interest(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    interest.reload

    assert interest.suppress_sending?
  end

  private

  def create_user(email:, opt_in_to_newsletter: true)
    create(:user, email:, opt_in_to_newsletter:)
  end

  def create_interest(email:)
    create(:interest, email:)
  end

  def create_purchase(email:)
    create(:purchase, customer_email: email)
  end

  def headers(token: EmailSubscriptionChangesController::TOKEN)
    { 'Authorization' => "Bearer #{token}" }
  end

  def params(stream: 'outbound', reason: 'HardBounce')
    data = JSON.parse(Rails.root.join('test/fixtures/files/postmark/webhook-data.json').read)
    data['MessageStream'] = stream
    data['SuppressionReason'] = reason
    data
  end
end
