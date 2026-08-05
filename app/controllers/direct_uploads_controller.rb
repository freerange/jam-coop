# frozen_string_literal: true

class DirectUploadsController < ActiveStorage::DirectUploadsController
  include RequestContext

  before_action :authenticate

  private

  def authenticate
    head :unauthorized unless Current.user
  end
end
