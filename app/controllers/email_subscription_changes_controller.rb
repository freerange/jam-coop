# frozen_string_literal: true

class EmailSubscriptionChangesController < ApplicationController
  TOKEN = Rails.application.credentials.postmark.webhooks_token

  skip_forgery_protection
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'not_found' }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: 'invalid', messages: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def create
    change = recipient.email_subscription_changes.create!(
      message_id: params[:MessageID],
      origin: params[:Origin],
      suppress_sending: params[:SuppressSending],
      suppression_reason: params[:SuppressionReason],
      changed_at: params[:ChangedAt]
    )
    render json: { email_subscription_change: { id: change.id } }, status: :created
  end

  private

  def recipient
    @recipient ||= User.find_by!(email: params[:Recipient])
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
