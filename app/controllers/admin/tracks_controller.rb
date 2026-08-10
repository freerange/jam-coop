# frozen_string_literal: true

module Admin
  class TracksController < ApplicationController
    before_action :set_album

    def new
      @track = authorize @album.tracks.new
    end

    def multiple
      @track = authorize @album.tracks.new
    end

    def edit
      @track = authorize Track.find(params.expect(:id))
    end

    def create
      @track = authorize @album.tracks.new(track_params)

      if @track.save
        if params[:commit] == 'Save and add another'
          redirect_to new_admin_artist_album_track_path(@track.artist, @track.album), notice: 'Track added'
        else
          redirect_to admin_artist_album_path(@track.artist, @track.album), notice: 'Track added'
        end
      else
        render :new, status: :unprocessable_content
      end
    end

    def create_multiple
      @tracks = params[:original].compact_blank.map do |original|
        blob = ActiveStorage::Blob.find_signed!(original)
        authorize Track.new(album: @album, original:, title: Track.title_from(blob))
      end

      if @tracks.all?(&:save)
        redirect_to admin_artist_album_path(@album.artist, @album), notice: 'Tracks added'
      else
        @track = @album.tracks.new
        render :multiple, status: :unprocessable_content
      end
    end

    def update
      @track = authorize Track.find(params.expect(:id))

      if @track.update(track_params)
        redirect_to admin_artist_album_path(@track.artist, @track.album), notice: 'Track updated'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @track = authorize Track.find(params.expect(:id))
      @track.destroy
      redirect_to admin_artist_album_path(@track.artist, @track.album), notice: 'Track deleted'
    end

    def move_higher
      @track = authorize Track.find(params.expect(:id))
      @track.move_higher
      redirect_to admin_artist_album_path(@track.artist, @track.album)
    end

    def move_lower
      @track = authorize Track.find(params.expect(:id))
      @track.move_lower
      redirect_to admin_artist_album_path(@track.artist, @track.album)
    end

    private

    def set_album
      @album = Album.friendly.find(params.expect(:album_id))
    end

    def track_params
      params.expect(track: %i[title original])
    end
  end
end
