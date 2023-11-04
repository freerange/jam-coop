# frozen_string_literal: true

class TracksController < ApplicationController
  before_action :set_track, only: %i[move_higher move_lower]

  def new
    @track = Track.new(album:)
  end

  def create
    @track = Track.new(track_params.merge(album:))

    if @track.save
      redirect_to artist_album_path(@track.artist, @track.album), notice: 'Track was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def move_higher
    @track.move_higher

    redirect_to artist_album_path(@track.artist, @track.album)
  end

  def move_lower
    @track.move_lower

    redirect_to artist_album_path(@track.artist, @track.album)
  end

  private

  def set_track
    @track = Track.find(params[:id])
  end

  def album
    artist.albums.friendly.find(params[:album_id])
  end

  def artist
    Artist.friendly.find(params[:artist_id])
  end

  # Only allow a list of trusted parameters through.
  def track_params
    params.require(:track).permit(:title, :original)
  end
end
