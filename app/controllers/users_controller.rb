# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def show
    authorize @user
  end

  private

  def set_user
    @user = Current.user
  end
end
