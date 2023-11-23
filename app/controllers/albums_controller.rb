# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :set_album, only: %i[show edit update publish unpublish request_publication]
  skip_before_action :authenticate, only: %i[show]

  def show
    skip_authorization
  end

  def new
    @album = Album.new(artist:)
    authorize @album
  end

  def edit
    authorize @album
  end

  def create
    @album = artist.albums.new(album_params)
    authorize @album

    if @album.save
      redirect_to artist_url(artist), notice: 'Artist was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @album

    if @album.update(album_params)
      redirect_to artist_album_url(@album.artist, @album), notice: 'Artist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    authorize @album

    @album.publish
    redirect_to artist_album_url(@album.artist, @album)
  end

  def unpublish
    authorize @album

    @album.unpublish
    redirect_to artist_album_url(@album.artist, @album)
  end

  def request_publication
    authorize @album

    @album.pending!
    redirect_to artist_album_url(@album.artist, @album),
                notice: "Thank you! We'll email you when your album is published."
  end

  private

  def set_album
    @album = artist.albums.friendly.find(params[:id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  def album_params
    params
      .require(:album)
      .permit(:title, :price, :cover, :about, :credits, :released_at, tracks_attributes: %i[id title original _destroy])
  end
end
