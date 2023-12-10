# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    authorize User
  end
end
