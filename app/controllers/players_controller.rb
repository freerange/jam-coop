# frozen_string_literal: true

class PlayersController < ApplicationController
  layout 'player'

  skip_before_action :authenticate

  helper_method :album, :artist

  def show
    skip_authorization
  end

  private

  def album
    @album ||= artist.albums.friendly.find(params[:album_id])
  end

  def artist
    @artist ||= Artist.friendly.find(params[:artist_id])
  end
end
