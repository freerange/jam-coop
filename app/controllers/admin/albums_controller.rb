# frozen_string_literal: true

module Admin
  class AlbumsController < ApplicationController
    def index
      authorize([:admin, Album])
    end
  end
end
