# frozen_string_literal: true

class TracksController < ApplicationController
  before_action :set_track, only: %i[edit update destroy]

  def new
    @track = Track.new(album:)
  end

  def edit; end

  def create
    @track = Track.new(track_params.merge(album:))

    if @track.save
      redirect_to artist_album_path(@track.artist, @track.album), notice: 'Track was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @track.update(track_params)
      redirect_to artist_album_path(@track.artist, @track.album), notice: 'Track was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @track.destroy

    redirect_to artist_album_path(@track.artist, @track.album), notice: 'Track was successfully destroyed.'
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
    params.require(:track).permit(:title)
  end
end
