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

  def publish
    if @album.publish
      AlbumMailer.with(album: @album).published.deliver_later
    else
      flash[:alert] = "Errors prohibited this album from being saved: #{@album.errors.full_messages.to_sentence}"
    end
    redirect_to artist_album_url(@album.artist, @album)
  end

  def unpublish
    @album.unpublish
    redirect_to artist_album_url(@album.artist, @album)
  end

  def request_publication
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
      .permit(:title, :price, :cover, :about, :credits, :released_on, tracks_attributes: %i[id title original _destroy])
  end

  def authorize_album
    authorize @album
  end
end
