# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :set_album, only: %i[show edit update publish unpublish]
  skip_before_action :authenticate, only: %i[show]

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
    if @album.update(album_params)
      redirect_to artist_url(@album.artist), notice: 'Artist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    @album.publish
    redirect_to artist_album_url(@album.artist, @album)
  end

  def unpublish
    @album.unpublish
    redirect_to artist_album_url(@album.artist, @album)
  end

  private

  def set_album
    @album = artist.albums.friendly.find(params[:id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  def album_params
    params.require(:album).permit(:title, :price, :cover, :about, :credits)
  end
end
