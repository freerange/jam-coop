# frozen_string_literal: true

module Admin
  class TracksController < ApplicationController
    before_action :set_track, only: %i[move_higher move_lower]

    def move_higher
      authorize @track

      @track.move_higher

      redirect_to artist_album_path(@track.artist, @track.album)
    end

    def move_lower
      authorize @track

      @track.move_lower

      redirect_to artist_album_path(@track.artist, @track.album)
    end

    private

    def set_track
      @track = Track.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def track_params
      params.expect(track: %i[title original])
    end
  end
end
