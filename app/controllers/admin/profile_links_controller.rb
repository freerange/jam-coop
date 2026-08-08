# frozen_string_literal: true

module Admin
  class ProfileLinksController < ApplicationController
    before_action :set_artist

    def new
      @profile_link = @artist.profile_links.build

      authorize @profile_link
    end

    def edit
      @profile_link = @artist.profile_links.find(params[:id])

      authorize @profile_link
    end

    def create
      @profile_link = @artist.profile_links.build(profile_link_params)

      authorize @profile_link

      if @profile_link.save
        redirect_to edit_artist_path(@artist), notice: 'Link added'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      @profile_link = @artist.profile_links.find(params[:id])

      authorize @profile_link

      if @profile_link.update(profile_link_params)
        redirect_to edit_artist_path(@artist), notice: 'Link updated'
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_artist
      @artist = Artist.friendly.find(params[:artist_id])
    end

    def profile_link_params
      params.expect(profile_link: %i[url])
    end
  end
end
