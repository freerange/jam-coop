# frozen_string_literal: true

module Admin
  class TracksController < ApplicationController
    before_action :set_album, only: %i[new create edit update]

    def new
      authorize @album

      @track = @album.tracks.new
    end

    def edit
      authorize @album

      @track = Track.find(params[:id])
    end

    def create
      authorize @album

      @track = @album.tracks.new(track_params)

      if @track.save
        redirect_to admin_artist_album_path(@track.artist, @track.album), notice: 'Track added'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      authorize @album

      @track = Track.find(params[:id])

      if @track.update(track_params)
        redirect_to admin_artist_album_path(@track.artist, @track.album), notice: 'Track updated'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def move_higher
      @track = Track.find(params[:id])
      authorize @track

      @track.move_higher

      redirect_to artist_album_path(@track.artist, @track.album)
    end

    def move_lower
      @track = Track.find(params[:id])
      authorize @track

      @track.move_lower

      redirect_to artist_album_path(@track.artist, @track.album)
    end

    private

    def set_album
      @album = Album.friendly.find(params[:album_id])
    end

    def track_params
      params.expect(track: %i[title original])
    end
  end
end
