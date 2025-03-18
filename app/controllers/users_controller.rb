# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, :set_stripe_account

  def show
    authorize @user
  end

  def update_newsletter_preference
    authorize @user

    if @user.update(user_params)
      redirect_to account_path, notice: 'Newsletter preference updated successfully.'
    else
      redirect_to account_path, alert: 'Unable to update newsletter preference.'
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def user_params
    params.require(:user).permit(:opt_in_to_newsletter)
  end

  def set_stripe_account
    @stripe_account = StripeConnectAccount.find_by(user: @user)
  end
end
