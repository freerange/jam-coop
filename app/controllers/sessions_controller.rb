# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]

  before_action :set_session, only: :destroy

  def index
    authorize Session

    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    skip_authorization
  end

  def create
    skip_authorization

    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to_previous_or_home
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: 'That email or password is incorrect'
    end
  end

  def destroy
    skip_authorization

    @session.destroy
    redirect_to(sessions_path, notice: 'That session has been logged out')
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end

  def redirect_to_previous_or_home
    if (return_url = session[:return_url])
      session.delete(:return_url)
      redirect_to return_url
    else
      redirect_to root_path, notice: 'Signed in successfully'
    end
  end
end
