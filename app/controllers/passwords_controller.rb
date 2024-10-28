# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :set_user

  def update
    authorize @user

    if !@user.authenticate(params[:current_password])
      flash[:incorrect_password] = 'The current password you entered is incorrect'
      redirect_to account_path
    elsif @user.update(user_params)
      redirect_to account_path, notice: 'Your password has been changed'
    else
      render 'users/show', status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
