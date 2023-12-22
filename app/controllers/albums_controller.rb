# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :build_album, only: %i[new create]
  before_action :set_album, except: %i[new create]
  skip_before_action :authenticate, only: %i[show]

  def show
    authorize @album
  end

  def new
    authorize @album
  end

  def edit
    authorize @album
  end

  def create
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
    AlbumMailer.with(album: @album).published.deliver_later
    redirect_to artist_album_url(@album.artist, @album)
  end

  def unpublish
    authorize @album

    @album.unpublish
    redirect_to artist_album_url(@album.artist, @album)
  end

  def request_publication
    authorize @album

    @album.pending
    AlbumMailer.with(album: @album).request_publication.deliver_later
    redirect_to artist_album_url(@album.artist, @album),
                notice: "Thank you! We'll email you when your album is published."
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
      .permit(:title, :price, :cover, :about, :credits, :released_at, tracks_attributes: %i[id title original _destroy])
  end
end
