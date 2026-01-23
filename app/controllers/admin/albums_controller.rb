# frozen_string_literal: true

module Admin
  class AlbumsController < ApplicationController
    before_action :build_album, only: %i[new create]
    before_action :set_album, only: %i[edit update]
    before_action :authorize_album

    def new; end
    def edit; end

    def create
      if @album.save
        @album.transcode_tracks
        redirect_to artist_album_path(@album.artist, @album), notice: 'Album was successfully created.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @album.update(album_params)
        redirect_to artist_album_path(@album.artist, @album), notice: 'Artist was successfully updated.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def build_album
      @album = artist.albums.new(params[:album].present? ? album_params : {})
    end

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

    def album_params
      params
        .expect(
          album: [
            :title,
            :price,
            :cover,
            :about,
            :credits,
            :released_on,
            :license_id,
            :publication_status,
            {
              tag_ids: [],
              tracks_attributes: [%i[id title original _destroy]]
            }
          ]
        )
    end

    def authorize_album
      authorize @album
    end
  end
end
