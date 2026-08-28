# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :set_album, except: %i[index random]
  skip_before_action :authenticate, only: %i[index show random]

  def index
    authorize Album

    @albums =
      policy_scope(Album)
      .includes(:artist, { cover_attachment: :blob })
      .published
      .order(first_published_on: :desc)
      .limit(20)
  end

  def show; end

  def random
    album = Album.published.order('RANDOM()').first
    authorize album, :show?

    redirect_to artist_album_path(album.artist, album)
  end

  private

  def set_album
    @album = authorize artist.albums.includes(:tracks).merge(Track.with_attachments).find(params.expect(:id))
  end

  def artist
    Artist.find(params.expect(:artist_id))
  end
end
