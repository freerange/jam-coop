# frozen_string_literal: true

class AlbumsController < ApplicationController
  def show
    @album = Album.find(params[:id])
  end
end
