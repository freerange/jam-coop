# frozen_string_literal: true

class AlbumsController < ApplicationController
  skip_before_action :authenticate

  def show
    artist = Artist.friendly.find(params[:artist_id])
    @album = artist.albums.friendly.find(params[:id])
  end
end
