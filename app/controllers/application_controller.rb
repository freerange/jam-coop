# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_current_request_details
  before_action :authenticate
  after_action :verify_authorized

  private

  def pundit_user
    Current.user || NullUser.new
  end

  def authenticate
    redirect_to main_app.log_in_path unless Current.user
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
    Current.session = Session.find_by(id: cookies.signed[:session_token])
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back_or_to main_app.root_path
  end
end
