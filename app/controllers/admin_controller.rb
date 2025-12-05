# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authorize_admin!

  private

  def authorize_admin!
    authorize :admin, :access?
  end
end
