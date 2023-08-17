# frozen_string_literal: true

class AlbumsController < ApplicationController
  def show
    @album = Album.friendly.find(params[:id])
  end
end
