# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :build_album, only: %i[new create]
  before_action :set_album, except: %i[new create]
  skip_before_action :authenticate, only: %i[show]
  before_action :authorize_album

  def show; end
  def new; end
  def edit; end

  def create
    if @album.save
      @album.transcode_tracks
      redirect_to artist_album_url(@album.artist, @album), notice: 'Album was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(album_params)
      redirect_to artist_album_url(@album.artist, @album), notice: 'Artist was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def build_album
    @album = artist.albums.new(params[:album].present? ? album_params : {})
  end

  def set_album
    @album = artist.albums.friendly.find(params[:id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  def album_params
    params
      .require(:album)
      .permit(:title, :price, :cover, :about, :credits, :released_on, :license_id, :publication_status,
              tracks_attributes: %i[id title original _destroy])
  end

  def authorize_album
    authorize @album
  end
end
