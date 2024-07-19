# frozen_string_literal: true

class RegistrationsController < ApplicationController
  skip_before_action :authenticate
  before_action :validate_cloudflare_turnstile, only: :create

  def new
    skip_authorization

    @user = User.new
  end

  def create
    skip_authorization

    @user = User.new(user_params)

    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      send_email_verification
      redirect_to root_path,
                  notice: "Welcome! You have signed up successfully. We have sent an email to #{@user.email}.
                           Please check your inbox to finish creating your account."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def send_email_verification
    UserMailer.with(user: @user).email_verification.deliver_later
  end
end
