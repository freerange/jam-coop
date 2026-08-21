# frozen_string_literal: true

module Avo
  class ApplicationController < BaseApplicationController
    include RequestContext

    before_action :authenticate

    private

    def authenticate
      redirect_to main_app.root_path unless ::Current.user&.admin?
    end
  end
end
