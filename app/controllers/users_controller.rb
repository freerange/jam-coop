# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def show; end

  def update_newsletter_preference
    if @user.update(user_params)
      redirect_to account_path, notice: 'Newsletter preference updated successfully.'
    else
      redirect_to account_path, alert: 'Unable to update newsletter preference.'
    end
  end

  private

  def set_user
    @user = authorize Current.user
  end

  def user_params
    params.expect(user: [:opt_in_to_newsletter])
  end
end
