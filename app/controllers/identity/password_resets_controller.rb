# frozen_string_literal: true

module Identity
  class PasswordResetsController < ApplicationController
    skip_before_action :authenticate
    before_action :skip_authorization
    before_action :set_user, only: %i[edit update]

    def new; end

    def edit; end

    def create
      if (@user = User.find_by(email: params[:email], verified: true))
        send_password_reset_email
        redirect_to log_in_path, notice: 'Check your email for reset instructions'
      else
        redirect_to new_identity_password_reset_path, alert: "You can't reset your password until you verify your email"
      end
    end

    def update
      if @user.update(user_params)
        revoke_tokens
        redirect_to(log_in_path, notice: 'Your password was reset successfully. Please sign in')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_user
      token = PasswordResetToken.find_signed!(params[:sid])
      @user = token.user
    rescue StandardError
      redirect_to new_identity_password_reset_path, alert: 'That password reset link is invalid'
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end

    def send_password_reset_email
      UserMailer.with(user: @user).password_reset.deliver_later
    end

    def revoke_tokens
      @user.password_reset_tokens.delete_all
    end
  end
end
