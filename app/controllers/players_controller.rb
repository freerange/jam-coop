# frozen_string_literal: true

class PlayersController < ApplicationController
  layout 'player'

  skip_before_action :authenticate
  after_action :allow_iframe

  content_security_policy do |policy|
    policy.frame_ancestors :self, 'https:'
  end

  helper_method :album, :artist, :player_dimensions

  def show
    skip_authorization
  end

  private

  def album
    @album ||= artist.albums.includes(
      tracks: [
        { transcodes: { file_attachment: :blob } }
      ]
    ).friendly.find(params[:album_id])
  end

  def artist
    @artist ||= Artist.friendly.find(params[:artist_id])
  end

  def player_dimensions
    [Rails.configuration.x.player.width, Rails.configuration.x.player.height].freeze
  end

  def allow_iframe
    response.headers.delete('X-Frame-Options')
  end
end
