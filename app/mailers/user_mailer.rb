# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def password_reset
    return if params[:user].suppress_sending?

    @user = params[:user]
    @signed_id = @user.password_reset_tokens.create.signed_id(expires_in: 20.minutes)

    mail to: @user.email, subject: 'Reset your password'
  end

  def email_verification
    return if params[:user].suppress_sending?

    @user = params[:user]
    @signed_id = @user.email_verification_tokens.create.signed_id(expires_in: 2.days)

    mail to: @user.email, subject: 'Verify your email'
  end

  def invitation_instructions
    @user = params[:user]
    @signed_id = @user.password_reset_tokens.create.signed_id(expires_in: 1.day)

    mail to: @user.email, subject: 'You have been invited to jam.coop'
  end
end
