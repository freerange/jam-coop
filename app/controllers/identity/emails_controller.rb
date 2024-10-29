# frozen_string_literal: true

module Identity
  class EmailsController < ApplicationController
    before_action :set_user

    def update
      authorize @user

      if !@user.authenticate(params[:current_password])
        flash[:emails_update_password_incorrect] = 'The password you entered is incorrect'
        redirect_to account_path
      elsif @user.update(email: params[:email])
        resend_verification_email_and_redirect
      else
        render 'users/show', status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = Current.user
    end

    def resend_verification_email_and_redirect
      if @user.email_previously_changed?
        resend_email_verification
        redirect_to account_path, notice: 'Your email has been changed'
      else
        redirect_to account_path
      end
    end

    def resend_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
  end
end
