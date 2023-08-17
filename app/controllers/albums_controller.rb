# frozen_string_literal: true

class AlbumsController < ApplicationController
  skip_before_action :authenticate

  def show
    @album = Album.find(params[:id])
  end
end
