# frozen_string_literal: true

class AlbumsController < ApplicationController
  def show
    artist = Artist.friendly.find(params[:artist_id])
    @album = artist.albums.friendly.find(params[:id])
  end
end
