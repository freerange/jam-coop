# frozen_string_literal: true

class AlbumsController < ApplicationController
  skip_before_action :authenticate
  before_action :set_album, only: %i[show edit update]

  def show; end

  def new
    @album = Album.new(artist:)
  end

  def edit; end

  def create
    @album = artist.albums.new(album_params)

    if @album.save
      redirect_to artist_url(artist), notice: 'Artist was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @lbum.update(album_params)
      redirect_to artist_url(@artist), notice: 'Artist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_album
    @album = artist.albums.friendly.find(params[:id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  def album_params
    params.require(:album).permit(:title, :cover)
  end
end
