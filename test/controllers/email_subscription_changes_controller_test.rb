# frozen_string_literal: true

require 'test_helper'

class EmailSubscriptionChangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.configuration.stubs(:postmark).returns({ webhooks_token: 'token' })
  end

  test 'suppresses sending for user' do
    user = create_user(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    user.reload
    assert user.suppress_sending?
    assert_equal Time.zone.iso8601(params['ChangedAt']), user.sending_suppressed_at
  end

  test 'suppresses sending for interest' do
    interest = create_interest(email: params['Recipient'])

    post(email_subscription_changes_path, headers:, params:)

    assert_response :created
    interest.reload
    assert interest.suppress_sending?
    assert_equal Time.zone.iso8601(params['ChangedAt']), interest.sending_suppressed_at
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

    assert_response :unprocessable_entity
    assert_equal({ 'error' => 'invalid', 'messages' => ['Email has an error'] }, response.parsed_body)
    assert_not user.reload.suppress_sending?
  end

  private

  def create_user(email:)
    create(:user, email:)
  end

  def create_interest(email:)
    create(:interest, email:)
  end

  def headers(token: EmailSubscriptionChangesController::TOKEN)
    { 'Authorization' => "Bearer #{token}" }
  end

  def params(except: [])
    JSON.parse(Rails.root.join('test/fixtures/files/postmark/hard-bounce.json').read).except(*except)
  end
end
