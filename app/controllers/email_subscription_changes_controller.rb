# frozen_string_literal: true

class EmailSubscriptionChangesController < ApplicationController
  class UnknownMessageStream < StandardError; end

  TOKEN = Rails.configuration.postmark[:webhooks_token]

  skip_forgery_protection
  before_action :authenticate
  before_action :ensure_record_exists

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'not_found' }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: 'invalid', messages: e.record.errors.full_messages }, status: :unprocessable_content
  end

  rescue_from UnknownMessageStream do |e|
    render json: { error: 'unknown_message_stream', messages: [e.message] }, status: :unprocessable_content
    Rollbar.error(e.message)
  end

  def create
    skip_authorization

    message_stream = params[:MessageStream]

    case message_stream
    when 'broadcast'
      update_newsletter_opt_in_for(user)
      update_sending_suppressed_for(interest)
    when 'outbound'
      update_sending_suppressed_for(user)
      update_sending_suppressed_for(interest)
      update_sending_suppressed_for(purchase)
    else
      raise UnknownMessageStream, "Unknown MessageStream: #{message_stream}"
    end
    render json: { user: { id: user&.id }, interest: { id: interest&.id } }, status: :created
  end

  private

  def update_sending_suppressed_for(recipient)
    return if recipient.blank?

    if params[:SuppressSending]
      recipient.update!(sending_suppressed_at: params[:ChangedAt])
    else
      recipient.update!(sending_suppressed_at: nil)
    end
  end

  def update_newsletter_opt_in_for(recipient)
    return if recipient.blank?

    if params[:SuppressSending]
      recipient.update!(opt_in_to_newsletter: false)
    else
      recipient.update!(opt_in_to_newsletter: true)
    end
  end

  def user
    @user ||= User.find_by(email: params[:Recipient])
  end

  def interest
    @interest ||= Interest.find_by(email: params[:Recipient])
  end

  def purchase
    @purchase ||= Purchase.find_by(customer_email: params[:Recipient])
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end

  def ensure_record_exists
    raise ActiveRecord::RecordNotFound if user.blank? && interest.blank? && purchase.blank?
  end
end
