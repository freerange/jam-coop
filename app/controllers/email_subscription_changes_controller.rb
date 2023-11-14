# frozen_string_literal: true

class EmailSubscriptionChangesController < ApplicationController
  TOKEN = Rails.application.credentials.postmark.webhooks_token

  skip_forgery_protection
  before_action :authenticate
  before_action :ensure_record_exists

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'not_found' }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: 'invalid', messages: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def create
    skip_authorization

    update_sending_suppressed_for(user)
    update_sending_suppressed_for(interest)
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

  def user
    @user ||= User.find_by(email: params[:Recipient])
  end

  def interest
    @interest ||= Interest.find_by(email: params[:Recipient])
  end

  def authenticate
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end

  def ensure_record_exists
    raise ActiveRecord::RecordNotFound if user.blank? && interest.blank?
  end
end
