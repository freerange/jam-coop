# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :set_album, except: %i[index random]
  skip_before_action :authenticate, only: %i[index show random]
  before_action :authorize_album, except: %i[index random]

  def index
    authorize Album

    @albums = Album.includes(:artist, { cover_attachment: :blob }).published.order(first_published_on: :desc).limit(20)
  end

  def show; end

  def random
    album = Album.published.order('RANDOM()').first
    authorize album, :show?

    redirect_to artist_album_path(album.artist, album)
  end

  private

  def set_album
    @album = artist.albums.includes(
      tracks: [
        { transcodes: { file_attachment: :blob } },
        { original_attachment: :blob }
      ]
    ).friendly.find(params[:id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  def authorize_album
    authorize @album
  end
end
