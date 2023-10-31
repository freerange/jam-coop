# frozen_string_literal: true

require 'test_helper'

class EmailSubscriptionChangesControllerTest < ActionDispatch::IntegrationTest
  test 'creates email subscription change' do
    create_user(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    change = EmailSubscriptionChange.last
    assert_equal params['MessageID'], change.message_id
    assert_equal params['Origin'], change.origin
    assert_equal params['SuppressSending'] == 'true', change.suppress_sending?
    assert_equal params['SuppressionReason'], change.suppression_reason
    assert_equal Time.zone.iso8601(params['ChangedAt']), change.changed_at
  end

  test 'does not create change if bearer token is not valid' do
    create_user(email: params['Recipient'])

    post(email_subscription_changes_path, headers: headers(token: 'invalid'), params:)

    assert_response :unauthorized
    assert_not EmailSubscriptionChange.last
  end

  test 'does not create change if user with email does not exist' do
    create_user(email: 'somebody-else@example.com')

    post(email_subscription_changes_path, headers:, params:)

    assert_response :not_found
    assert_equal({ 'error' => 'not_found' }, response.parsed_body)
    assert_not EmailSubscriptionChange.last
  end

  test 'does not create change if validation error' do
    create_user(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params: params(except: ['SuppressionReason']))

    assert_response :unprocessable_entity
    assert_equal({ 'error' => 'invalid', 'messages' => ["Suppression reason can't be blank"] }, response.parsed_body)
    assert_not EmailSubscriptionChange.last
  end

  private

  def create_user(email:)
    User.create!(email:, password: SecureRandom.hex)
  end

  def headers(token: EmailSubscriptionChangesController::TOKEN)
    { 'Authorization' => "Bearer #{token}" }
  end

  def params(except: [])
    JSON.parse(Rails.root.join('test/fixtures/files/postmark/hard-bounce.json').read).except(*except)
  end
end
