# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'new'

  def show
    authorize User
  end
end
